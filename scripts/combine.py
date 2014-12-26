import numpy as np
import sys
import time
from itertools import product
import os
import pdb
import cPickle

def normalize(data):
    norm = np.sqrt((data ** 2).sum())
    return data / norm

def load(e, classifiers=["RNNLM", "PARAGRAPH", "NBSVM"], path="scores"):
    """ returns an array containing the scores of the specified classifiers.
    Note that we center the scores to 0."""
    assert e in ["TEST", "VALID"]
    probas = []
    for c in classifiers:
        assert c in ["RNNLM", "PARAGRAPH", "NBSVM"]
        data = np.loadtxt(os.path.join(path,"-".join([c, e])))
        if "RNNLM" in c:
            data = normalize(data[:,2] - 1)
        elif "PARAG" in c or "NBSVM" in c:
            data = normalize(data[:, 2] - 0.5)
        else:
            raise
        probas += [data]
    x = np.vstack(probas).T
    y = np.vstack([np.ones((x.shape[0]//2, 1)), np.zeros((x.shape[0]//2, 1))])
    return (x, y)

def accuracy(k, d):
    """ d is an array of shape nsamples, nclassifiers
    k is an array of size nclassifiers
    this function return the accuracy of the linear combination
    with k coefficients
    """
    x, y = d
    output = [k[i] * x[:, i] for i in range(len(k))]
    pred = np.vstack(output).sum(0)
    cnt = ((pred < 0) == y.T).mean()
    return cnt * 100.

def ensemble(d, classifiers):
    """ computes the weigths of each ensemble
    according to the contribution of each model
    on the valid set """
    output = []
    x, y = d
    for i, c in enumerate(classifiers):
        k = np.zeros(len(classifiers))
        k[i] = 1
        acc = accuracy(k, d)
        output += [acc]
    k = np.array(output)
    k /= k.sum()
    best = accuracy(k, d)
    return k, best 
 
if __name__ == "__main__":
    print "\n"
    # solo
    solos = [["RNNLM"], ["PARAGRAPH"], ["NBSVM"]]
    for c in solos:
        valid, test = load("VALID", c), load("TEST", c)
        vacc, tacc = accuracy([1], valid), accuracy([1], test)
        print c, "\t valid / test %.2f / %.2f" % (vacc, tacc)
    print "\n"
    # duo
    duos = [["RNNLM", "PARAGRAPH"],
            ["RNNLM", "NBSVM"],
            ["PARAGRAPH", "NBSVM"]]
    for c in duos:
        valid, test = load("VALID", c), load("TEST", c)
        k, vacc = ensemble(valid, c)
        tacc = accuracy(k, test)
        print c, "\t valid / test %.2f / %.2f - weigths =" % (vacc, tacc), k
    print "\n"
    # trios
    trios = [["RNNLM", "PARAGRAPH", "NBSVM"]]
    for c in trios:
        valid, test = load("VALID", c), load("TEST", c)
        k, vacc = ensemble(valid, c)
        tacc = accuracy(k, test)
        print c, "\t valid / test %.2f / %.2f - weigths" % (vacc, tacc), k
    print "\n"
