unzip apache-artemis-2.51.0-bin.zip && apache-artemis-2.51.0/bin/artemis create mybroker --user deepphe --password deepphe --allow-anonymous

cd neutropenia && mvn clean package && source ./test_venv/bin/activate
{
java -cp target/ctakes-neutropenia-endpoint-7.0.0-SNAPSHOT-jar-with-dependencies.jar \
     org.apache.ctakes.core.pipeline.PiperFileRunner \
	   -p org/apache/ctakes/neutropenia/pipeline/ClingenAnnotator \
	   -i ../input \
	   -o ../output \
	   -a ../mybroker -v ./test_venv/bin/python
} || {
cd ..
rm -rf apache-artemis-2.51.0-bin
}
