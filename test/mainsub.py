import pytest
import os
import networkx as nx
from networkx.algorithms.isomorphism import GraphMatcher
from networkx.readwrite import json_graph
from networkx.algorithms import isomorphism
import matplotlib.pyplot as plt

# import gmatch4py as gm
import json

# g1 = nx.readwrite.json_graph.adjacency_data()
with open('sub.json') as f:
    json_data = json.loads(f.read())

with open('main.json') as f2:
    json_data_main = json.loads(f2.read())

# G = nx.DiGraph()
#
# G.add_nodes_from(
#     elem['id']
#     for elem in json_data['nodes'])
#
# G.add_edges_from(
#     (elem['id'], elem['id'])
#     for elem in json_data['adjacency'])

# nx.draw(G, with_labels=True)

# data = json_graph.adjacency_data(json_data)

# G = nx.Graph([(1, 2)])
# data = json_graph.adjacency_data(G)
# print(data)
# H = json_graph.adjacency_graph(data)

sub_graph = json_graph.adjacency_graph(json_data)
main_graph = json_graph.adjacency_graph(json_data_main)

GM = isomorphism.GraphMatcher(sub_graph,main_graph)

# for subgraph in GM.subgraph_isomorphisms_iter():
#     print(subgraph)

# nx.draw_networkx(sub_graph)
# nx.draw_networkx(main_graph)
# plt.show()

# ged=gm.GraphEditDistance(1,1,1,1) # all edit costs are equal to 1
# result=ged.compare([main_graph,sub_graph],None)
# print(result)

