# coding = utf-8
import numpy as np
cimport numpy as np
from .graph cimport Graph
from .base cimport Base
from cython.parallel cimport prange,parallel
from ..helpers.general import parsenx2graph

cdef class MCS(Base):
    """
    *A graph distance metric based on the maximal common subgraph, H. Bunke and K. Shearer,
    Pattern Recognition Letters, 1998*
    """
    def __init__(self):
        Base.__init__(self,0,True)

    cpdef np.ndarray compare_old(self,list listgs, list selected):
        cdef int n = len(listgs)
        cdef np.ndarray comparison_matrix = np.zeros((n, n))
        for i in range(n):
            for j in range(i, n):
                g1,g2=listgs[i],listgs[j]
                f=self.isAccepted(g1,i,selected)
                if f:
                    comparison_matrix[i, j] = self.s_mcs(g1,g2)
                else:
                    comparison_matrix[i, j] = 0.
                comparison_matrix[j, i] = comparison_matrix[i, j]
        return comparison_matrix
    
    cpdef np.ndarray compare(self,list listgs, list selected):
        cdef int n = len(listgs)
        cdef double [:,:] comparison_matrix = np.zeros((n, n))
        cdef bint[:] selected_test = self.get_selected_array(selected,n)
        cdef list new_gs=parsenx2graph(listgs)
        cdef long[:] n_nodes = np.array([g.size() for g in new_gs])
        cdef double [:,:] intersect_len_nodes = np.zeros((n, n))
        cdef int i,j
        for i in range(n):
            for j in range(i,n):
                intersect_len_nodes[i][j]=new_gs[i].size_node_intersect(new_gs[j])

        with nogil, parallel(num_threads=4):
            for i in prange(n,schedule='static'):
                for j in range(i, n):
                    if  n_nodes[i] > 0 and n_nodes[j] > 0  and selected_test[i]:
                        comparison_matrix[i][j] = intersect_len_nodes[i][j]/max(n_nodes[i],n_nodes[j])
                    else:
                        comparison_matrix[i][j] = 0.
                    comparison_matrix[j][i] = comparison_matrix[i][j]
        return np.array(comparison_matrix)

    def s_mcs(self,G, H):
        """
        Return the MCS measure value between
        Parameters
        ----------
        G : networkx.Graph
            First Graph
        H : networkx.Graph
            Second Graph

        Returns
        -------

        """

        return len(self.mcs(G, H)) / float(max(len(G), len(H)))

