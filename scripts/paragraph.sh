mkdir word2vec; cd word2vec
cp ../../iclr15/scripts/word2vec.c .
gcc word2vec.c -o word2vec -lm -pthread -O3 -march=native -funroll-loops

cat ../data/full-train-pos.txt ../data/full-train-neg.txt ../data/test-pos.txt ../data/test-neg.txt ../data/train-unsup.txt > alldata.txt
awk 'BEGIN{a=0;}{print "_*" a " " $0; a++;}' < alldata.txt > alldata-id.txt

time ./word2vec -train alldata-id.txt -output vectors.txt -cbow 0 -size 100 -window 10 -negative 5 -hs 0 -sample 1e-4 -threads 40 -binary 0 -iter 20 -min-count 1 -sentence-vectors 1
grep '_\*' vectors.txt > sentence_vectors.txt

# test
head sentence_vectors.txt -n 25000 | awk 'BEGIN{a=0;}{if (a<12500) printf "1 "; else printf "-1 "; for (b=1; b<NF; b++) printf b ":" $(b+1) " "; print ""; a++;}' > full-train.txt
head sentence_vectors.txt -n 50000 | tail -n 25000 | awk 'BEGIN{a=0;}{if (a<12500) printf "1 "; else printf "-1 "; for (b=1; b<NF; b++) printf b ":" $(b+1) " "; print ""; a++;}' > test.txt

../liblinear-1.96/train -s 0 full-train.txt model.logreg
../liblinear-1.96/predict -b 1 test.txt model.logreg out.logreg
tail -n 25000 out.logreg > ../scores/PARAGRAPH-TEST

# valid
head -n 10000 full-train.txt > small-train.txt
head -n 22500 full-train.txt | tail -n 10000 >> small-train.txt
head -n 12500 full-train.txt | tail -n 2500 > valid.txt
tail -n 2500 full-train.txt >> valid.txt

../liblinear-1.96/train -s 0 small-train.txt model.logreg
../liblinear-1.96/predict -b 1 valid.txt model.logreg out.logreg
tail -n 5000 out.logreg > ../scores/PARAGRAPH-VALID

rm alldata.txt alldata-id.txt vectors.txt
rm full-train.txt test.txt
rm model.logreg out.logreg
cd ..
