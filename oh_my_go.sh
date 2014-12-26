chmod +x scripts/*.sh
cd ..
mkdir iclr15_run; cd iclr15_run
mkdir scores

../iclr15/scripts/data.sh
../iclr15/scripts/install_liblinear.sh
../iclr15/scripts/rnnlm.sh
../iclr15/scripts/paragraph.sh
../iclr15/scripts/nbsvm.sh
../iclr15/scripts/ensemble.sh

cd ../iclr15
