from sklearn import tree
from sklearn.datasets import load_iris

#basic use
"
X = [[0,0],[1,1]]
Y= [0,1]
clf = tree.DecisionTreeClassifier()
clf = clf.fit(X,Y)

probs = clf.predict_proba([[2., 2.]])
print(probs)

pred = clf.predict([[2.,2.]])
print(pred)
"
iris = load_iris()
clf = tree.DecisionTreeClassifier()
clf = clf.fit(iris.data,iris.target)

with open("iris.dot",'w') as f:
    f = tree.export_graphviz(clf, out_file=f)

