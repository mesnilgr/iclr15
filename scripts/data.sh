#this function will convert text to lowercase and will disconnect punctuation and special symbols from words
function normalize_text {
  awk '{print tolower($0);}' < $1 | sed -e 's/\./ \. /g' -e 's/<br \/>/ /g' -e 's/"/ " /g' \
  -e 's/,/ , /g' -e 's/(/ ( /g' -e 's/)/ ) /g' -e 's/\!/ \! /g' -e 's/\?/ \? /g' \
  -e 's/\;/ \; /g' -e 's/\:/ \: /g' > $1-norm
}

wget http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz
tar -xvf aclImdb_v1.tar.gz

for j in train/pos train/neg test/pos test/neg train/unsup; do
  for i in `ls aclImdb/$j`; do cat aclImdb/$j/$i >> temp; awk 'BEGIN{print;}' >> temp; done
  normalize_text temp
  mv temp-norm aclImdb/$j/norm.txt
  rm temp
done

mkdir data
mv aclImdb/train/pos/norm.txt data/full-train-pos.txt
mv aclImdb/train/neg/norm.txt data/full-train-neg.txt
mv aclImdb/test/pos/norm.txt data/test-pos.txt
mv aclImdb/test/neg/norm.txt data/test-neg.txt
mv aclImdb/train/unsup/norm.txt data/train-unsup.txt

cd data
head -n 10000 full-train-pos.txt > small-train-pos.txt
head -n 10000 full-train-neg.txt > small-train-neg.txt
tail -n 2500 full-train-pos.txt > valid-pos.txt
tail -n 2500 full-train-neg.txt > valid-neg.txt
cd ..

rm -r aclImdb
rm aclImdb_v1.tar.gz
