java -cp target/ctakes-neutropenia-endpoint-7.0.0-SNAPSHOT-jar-with-dependencies.jar \
     org.apache.ctakes.core.pipeline.PiperFileRunner \
	   -p org/apache/ctakes/neutropenia/pipeline/ClingenAnnotator \
	   -i ../input \
	   -o ../output \
	   -a ../mybroker -v ./test_venv/bin/python
