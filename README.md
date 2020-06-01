gcloud builds submit . --config=cloudbuild.yaml


https://github.com/RPi-Distro/pi-gen

```
git clone https://github.com/RPi-Distro/pi-gen
cp pi-gen-cloudbuild.yaml pigen/cloudbuild.yaml
cd pi-gen

Submit the builder to your project:

gcloud builds submit .

Navigate back to your project root directory:

cd ../..

Remove the repository from your root directory:

rm -rf cloud-builders-community/
```


DOCKER_BUILDKIT=1 docker build .




https://github.com/pftf/RPi4

https://github.com/sgielen/picl-k3os-image-generator


xorriso