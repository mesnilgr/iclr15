iclr15
======

This code reproduces the results of the following paper:

Grégoire Mesnil, Tomas Mikolov, Marc'Aurelio and Yoshua Bengio: Ensemble of Generative and Discriminative Techniques for Sentiment Analysis of Movie Reviews; Submitted to the workshop track of ICLR 2015. http://arxiv.org/abs/1412.5335

To reproduce the results:

```
git clone git@github.com:mesnilgr/iclr15.git
cd iclr15; chmod +x oh_my_go.sh
./oh_my_go.sh
```

#In terms of timing:

#downloading the data, tokenizing this will take 68 mins. Note that most of the time is spent dowloading and tokenizing. Once the data has been downloaded and tokenized, training an NB-SVM only takes ~2 mins for uni+bigrams and <5 mins for uni+bi+trigrams.
#
