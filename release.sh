#!/bin/bash

TARGET="$1"

if [[ $# -eq 0 ]] ; then
    echo 'target required'
    exit 0
fi

cd "${TARGET}"

sed -i -e 's#source = "../oke"#source = "./oke"#g' provider.tf
mkdir oke
cp ../oke/*.tf oke/

sed -i -e 's#source = "../demo-app"#source = "./demo-app"#g' main.tf
mkdir demo-app
cp -rp ../demo-app/{*.tf,ingressroutes,manifests} demo-app/

zip -q "../${TARGET}-stack.zip" schema.yaml *.tf oke/*.tf demo-app/{*.tf,ingressroutes/*.tftpl,manifests/*.yaml}

rm -rf oke/
sed -i -e 's#source = "./oke"#source = "../oke"#g' provider.tf

rm -rf demo-app
sed -i -e 's#source = "./demo-app"#source = "../demo-app"#g' main.tf

cd ..
