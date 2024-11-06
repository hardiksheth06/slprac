import sys

def prim_mst(graph):
    num_vertices = len(graph)
    selected = [False] * num_vertices
    mst_matrix = [[0] * num_vertices for _ in range(num_vertices)]
    selected[0] = True
    num_edges = 0

    while num_edges < num_vertices - 1:
        min_edge = sys.maxsize
        u = v = -1

        for i in range(num_vertices):
            if selected[i]:
                for j in range(num_vertices):
                    if not selected[j] and graph[i][j]:
                        if min_edge > graph[i][j]:
                            min_edge = graph[i][j]
                            u, v = i, j

        if u != -1 and v != -1:
            selected[v] = True
            mst_matrix[u][v] = graph[u][v]
            mst_matrix[v][u] = graph[v][u]
            num_edges += 1

    return mst_matrix

def print_matrix(matrix):
    print("MST Matrix:")
    for row in matrix:
        print(" ".join(map(str, row)))

def main():
    print("Minimum Spanning Tree (Prim's Algorithm)")
    num_vertices = int(input("Enter the number of vertices: "))
    graph = [[0] * num_vertices for _ in range(num_vertices)]
    num_edges = int(input("Enter the number of edges: "))
    print("Enter the edges in the format: vertex1 vertex2 weight")

    for _ in range(num_edges):
        u, v, weight = map(int, input().split())
        graph[u][v] = weight
        graph[v][u] = weight

    mst_matrix = prim_mst(graph)
    print_matrix(mst_matrix)

if __name__ == "__main__":
    main()
