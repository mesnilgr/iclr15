mkdir rnnlm
cd rnnlm
wget http://www.fit.vutbr.cz/~imikolov/rnnlm/rnnlm-0.3e.tgz
tar -xvf rnnlm-0.3e.tgz
g++ -lm -O3 -march=native -Wall -funroll-loops -ffast-math -c rnnlmlib.cpp
g++ -lm -O3 -march=native -Wall -funroll-loops -ffast-math rnnlm.cpp rnnlmlib.o -o rnnlm

# train with a small valid set
head ../data/small-train-pos.txt -n 9800 > train
tail ../data/small-train-pos.txt -n 200 > valid
./rnnlm -rnnlm model-pos -train train -valid valid -hidden 50 -direct-order 3 -direct 200 -class 100 -debug 2 -bptt 4 -bptt-block 10 -binary

head ../data/small-train-neg.txt -n 9800 > train
tail ../data/small-train-neg.txt -n 200 > valid
./rnnlm -rnnlm model-neg -train train -valid valid -hidden 50 -direct-order 3 -direct 200 -class 100 -debug 2 -bptt 4 -bptt-block 10 -binary

cat ../data/valid-pos.txt ../data/valid-neg.txt > valid.txt
awk 'BEGIN{a=0;}{print a " " $0; a++;}' < valid.txt > valid-id.txt
./rnnlm -rnnlm model-pos -test valid-id.txt -debug 0 -nbest > model-pos-score
./rnnlm -rnnlm model-neg -test valid-id.txt -debug 0 -nbest > model-neg-score
paste model-pos-score model-neg-score | awk '{print $1 " " $2 " " $1/$2;}' > ../scores/RNNLM-VALID
# clean up
rm valid.txt train valid valid-id.txt model-pos model-neg

# train with the biggest train set
head ../data/full-train-pos.txt -n 12300 > train
tail ../data/full-train-pos.txt -n 200 > valid
./rnnlm -rnnlm model-pos -train train -valid valid -hidden 50 -direct-order 3 -direct 200 -class 100 -debug 2 -bptt 4 -bptt-block 10 -binary

head ../data/full-train-neg.txt -n 12300 > train
tail ../data/full-train-neg.txt -n 200 > valid
./rnnlm -rnnlm model-neg -train train -valid valid -hidden 50 -direct-order 3 -direct 200 -class 100 -debug 2 -bptt 4 -bptt-block 10 -binary

cat ../data/test-pos.txt ../data/test-neg.txt > test.txt
awk 'BEGIN{a=0;}{print a " " $0; a++;}' < test.txt > test-id.txt
./rnnlm -rnnlm model-pos -test test-id.txt -debug 0 -nbest > model-pos-score
./rnnlm -rnnlm model-neg -test test-id.txt -debug 0 -nbest > model-neg-score
paste model-pos-score model-neg-score | awk '{print $1 " " $2 " " $1/$2;}' > ../scores/RNNLM-TEST
rm test.txt train valid test-id.txt model-pos-score model-neg-score model-pos model-neg
cd ..
