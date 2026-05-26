from collections.abc import Iterable
import logging
import os

from ctakes_pbj.component.cas_annotator import CasAnnotator
from ctakes_pbj.type_system.ctakes_types import (
    DocumentPath,
    SignSymptomMention,
    LabMention,
    BinaryTextRelation,
)
from .validation import Validator
from neutropenia_clingen_agents.agents.clingen_workflow import (
    quickstart,
)
from neutropenia_clingen_agents.agents.state_model import Sentence, ClinGenMention
from ctakes_pbj.type_system import ctakes_types
from ctakes_pbj.pbj_tools.create_type import add_type
from ctakes_pbj.pbj_tools.create_relation import create_relation

logger = logging.getLogger(__name__)

logging.basicConfig(
    format="%(asctime)s - %(levelname)s - %(name)s -   %(message)s",
    datefmt="%m/%d/%Y %H:%M:%S",
    level=logging.INFO,
)


def get_note_basename(cas) -> str:
    document_path_collection = cas.select(DocumentPath)
    document_path = getattr(document_path_collection[0], "documentPath", None)
    if document_path is None:
        raise ValueError("Missing document path for CAS")
    return os.path.basename(document_path)


class ClinGenAnnotator(CasAnnotator):
    def __init__(
        self,
    ):
        self.clingen_agent_workflow = None
        self.validator = None

    def initialize(self):
        self.clingen_agent_workflow = quickstart()
        self.validator = Validator()

    def get_annotated_sentences(self, cas) -> Iterable[Sentence]:
        if self.clingen_agent_workflow is None:
            raise ValueError("LangGraph workflow not initialized")
        for section in cas.select(ctakes_types.Segment):
            section_id = getattr(section, "id", None)
            if isinstance(section_id, str) and section_id.startswith("RELEVANT"):
                for cas_sentence in cas.select_covered(ctakes_types.Sentence, section):
                    raw_sentence = Sentence(
                        offsets=(cas_sentence.begin, cas_sentence.end),
                        sentence_string=cas_sentence.get_covered_text(),
                        raw_output=None,
                        mention=None,
                    )
                    try:
                        yield self.clingen_agent_workflow.invoke(raw_sentence)
                    except Exception:
                        print(f"Issue with sentence {raw_sentence} - skipping")
                        logger.error(
                            "Issue with sentence %s - skipping", str(raw_sentence)
                        )

    @staticmethod
    def insert_clingen_mention(
        cas, mention: ClinGenMention, sentence_begin: int
    ) -> None:
        sign_symptom_mention_type = cas.typesystem.get_type(SignSymptomMention)
        lab_mention_type = cas.typesystem.get_type(LabMention)
        relation_type = cas.typesystem.get_type(BinaryTextRelation)
        gene = (
            add_type(
                cas,
                sign_symptom_mention_type,
                mention.gene[0] + sentence_begin,
                mention.gene[1] + sentence_begin,
            )
            if mention.gene is not None
            else None
        )
        syntax_n = (
            add_type(
                cas,
                sign_symptom_mention_type,
                mention.syntax_n[0] + sentence_begin,
                mention.syntax_n[1] + sentence_begin,
            )
            if mention.syntax_n is not None
            else None
        )

        syntax_p = (
            add_type(
                cas,
                sign_symptom_mention_type,
                mention.syntax_p[0] + sentence_begin,
                mention.syntax_p[1] + sentence_begin,
            )
            if mention.syntax_p is not None
            else None
        )

        vaf = (
            add_type(
                cas,
                lab_mention_type,
                mention.vaf[0] + sentence_begin,
                mention.vaf[1] + sentence_begin,
            )
            if mention.vaf is not None
            else None
        )

        variant_type = (
            add_type(
                cas,
                lab_mention_type,
                mention.variant_type[0] + sentence_begin,
                mention.variant_type[1] + sentence_begin,
            )
            if mention.variant_type is not None
            else None
        )

        if gene is None:
            raise ValueError(f"Bad mention - missing gene {mention}")
        if syntax_n is not None:
            create_relation(
                cas=cas,
                relation_type=relation_type,
                category="syntax_n",
                source=gene,
                target=syntax_n,
            )

        if syntax_p is not None:
            create_relation(
                cas=cas,
                relation_type=relation_type,
                category="syntax_p",
                source=gene,
                target=syntax_p,
            )
        if vaf is not None:
            create_relation(
                cas=cas,
                relation_type=relation_type,
                category="vaf",
                source=gene,
                target=vaf,
            )
        if variant_type is not None:
            create_relation(
                cas=cas,
                relation_type=relation_type,
                category="variant_type",
                source=gene,
                target=variant_type,
            )

    def process(self, cas):
        for sentence in self.get_annotated_sentences(cas):
            mention = self.validator.parse_valid_clingen_mention(sentence)
            if mention is not None:
                sentence_begin, _ = sentence["offsets"]
                ClinGenAnnotator.insert_clingen_mention(
                    cas=cas, mention=mention, sentence_begin=sentence_begin
                )
