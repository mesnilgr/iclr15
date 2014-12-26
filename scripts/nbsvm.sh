git clone git@github.com:mesnilgr/nbsvm.git
cd nbsvm
python nbsvm.py --liblinear ../liblinear-1.96 --ptrain ../data/small-train-pos.txt --ntrain ../data/small-train-neg.txt --ptest ../data/valid-pos.txt --ntest ../data/valid-neg.txt --ngram 123 --out ../scores/NBSVM-VALID
tail -n 5000 ../scores/NBSVM-VALID > tmp; mv tmp ../scores/NBSVM-VALID
python nbsvm.py --liblinear ../liblinear-1.96 --ptrain ../data/full-train-pos.txt --ntrain ../data/full-train-neg.txt --ptest ../data/test-pos.txt --ntest ../data/test-neg.txt --ngram 123 --out ../scores/NBSVM-TEST
tail -n 25000 ../scores/NBSVM-TEST > tmp; mv tmp ../scores/NBSVM-TEST
cd ..
