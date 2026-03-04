import logging
import os

from collections.abc import Collection
from ctakes_pbj.component.cas_annotator import CasAnnotator
from ctakes_pbj.type_system.ctakes_types import DocumentPath
from neutropenia_clingen_agents.agents.clingen_workflow import build_agent_workflow

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
        model_id: str,
        max_new_tokens: int,
        max_length: int,
        system_prompt: str,
        examples_file: str | None,
        sample_document: str | None,
        sample_answer: str | None,
        attributes: Collection[str] | None,
    ):
        pass

    def initialize(self):
        self.agentic_workflow = build_agent_workflow(
            model_id=self.model_id,
            max_new_tokens=self.max_new_tokens,
            max_length=self.max_length,
            system_prompt=self.system_prompt,
            examples_file=self.examples_file,
            sample_document=self.sample_document,
            sample_answer=self.sample_answer,
            attributes=self.attributes,
        )

    def declare_params(self, arg_parser):
        arg_parser.add_arg("--model_path")

    def init_params(self, args):
        self.model_id = args.model_id
        self.max_new_tokens = args.max_new_tokens
        self.max_length = args.max_length
        self.system_prompt = args.system_prompt
        self.examples_file = args.examples_file
        self.sample_document = args.sample_document
        self.sample_answer = args.sample_answer
        self.attributes = args.attributes

    def process(self, cas):
        pass
