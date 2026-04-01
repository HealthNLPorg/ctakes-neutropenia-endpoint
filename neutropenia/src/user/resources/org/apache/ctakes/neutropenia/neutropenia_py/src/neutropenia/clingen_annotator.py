import logging
import os

from ctakes_pbj.component.cas_annotator import CasAnnotator
from ctakes_pbj.type_system.ctakes_types import (
    DocumentPath,
    SignSymptomMention,
    LabMention,
)
from neutropenia_clingen_agents.agents.clingen_workflow import (
    quickstart,
)
from neutropenia_clingen_agents.agents.state_model import Sentence
from ctakes_pbj.type_system import ctakes_types
from ctakes_pbj.pbj_tools.create_type import add_type

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
        self.agentic_workflow = None

    def initialize(self):
        self.agentic_workflow = quickstart()

    def process(self, cas):
        sign_symptom_mention_type = cas.typesystem.get_type(SignSymptomMention)
        lab_mention_type = cas.typesystem.get_type(LabMention)
        if self.agentic_workflow is None:
            raise ValueError("LangGraph workflow not initialized")
        for cas_sentence in cas.select(ctakes_types.Sentence):
            raw_sentence = Sentence(
                offsets=(cas_sentence.begin, cas_sentence.end),
                sentence_string=cas_sentence.get_covered_text(),
                raw_output=None,
                mention=None,
            )
            annotated_sentence = self.agentic_workflow.invoke(raw_sentence)
            mention = annotated_sentence.get("mention")
            if mention is not None:
                # TODO figure out insertion logic
                gene_offsets = mention.gene
                if gene_offsets is not None:
                    local_gene_begin, local_gene_end = gene_offsets
                    add_type(
                        cas,
                        sign_symptom_mention_type,
                        local_gene_begin + cas_sentence.begin,
                        local_gene_end + cas_sentence.begin,
                    )

                syntax_n_offsets = mention.syntax_n
                if syntax_n_offsets is not None:
                    local_syntax_n_begin, local_syntax_n_end = syntax_n_offsets
                    add_type(
                        cas,
                        sign_symptom_mention_type,
                        local_syntax_n_begin + cas_sentence.begin,
                        local_syntax_n_end + cas_sentence.begin,
                    )

                syntax_p_offsets = mention.syntax_p
                if syntax_p_offsets is not None:
                    local_syntax_p_begin, local_syntax_p_end = syntax_p_offsets
                    add_type(
                        cas,
                        sign_symptom_mention_type,
                        local_syntax_p_begin + cas_sentence.begin,
                        local_syntax_p_end + cas_sentence.begin,
                    )

                vaf_offsets = mention.vaf
                if vaf_offsets is not None:
                    local_vaf_begin, local_vaf_end = vaf_offsets
                    add_type(
                        cas,
                        lab_mention_type,
                        local_vaf_begin + cas_sentence.begin,
                        local_vaf_end + cas_sentence.begin,
                    )

                variant_type_offsets = mention.variant_type
                if variant_type_offsets is not None:
                    local_variant_type_begin, local_variant_type_end = (
                        variant_type_offsets
                    )
                    add_type(
                        cas,
                        lab_mention_type,
                        local_variant_type_begin + cas_sentence.begin,
                        local_variant_type_end + cas_sentence.begin,
                    )
