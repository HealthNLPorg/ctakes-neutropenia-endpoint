from ctakes_pbj.component.pbj_receiver import PBJReceiver
from neutropenia.clingen_annotator import ClinGenAnnotator
from ctakes_pbj.component.pbj_sender import PBJSender
from ctakes_pbj.pipeline.pbj_pipeline import PBJPipeline


def main():
    print("TESTING PIPELINE BUILDING PYTHON SIDE")
    pipeline = PBJPipeline()
    pipeline.reader(PBJReceiver())
    pipeline.add(ClinGenAnnotator())
    pipeline.add(PBJSender())
    pipeline.initialize()
    pipeline.run()


main()
