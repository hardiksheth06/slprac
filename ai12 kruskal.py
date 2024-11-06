class Graph:
    def __init__(self, vertices):
        self.V = vertices  # Number of vertices
        self.graph = []  # List to store all edges in the format (weight, u, v)

    # Function to add an edge to the graph
    def add_edge(self, u, v, w):
        self.graph.append((w, u, v))

    # Utility function to find the set (or parent) of an element using path compression
    def find(self, parent, i):
        if parent[i] == i:
            return i
        else:
            parent[i] = self.find(parent, parent[i])
            return parent[i]

    # Utility function to perform union of two sets
    def union(self, parent, rank, x, y):
        root_x = self.find(parent, x)
        root_y = self.find(parent, y)

        # Attach the smaller rank tree under the higher rank tree
        if rank[root_x] < rank[root_y]:
            parent[root_x] = root_y
        elif rank[root_x] > rank[root_y]:
            parent[root_y] = root_x
        else:
            parent[root_y] = root_x
            rank[root_x] += 1

    # Function to implement Kruskal's algorithm
    def kruskal_mst(self):
        # Initialize the result list to store the edges in the MST
        mst = []

        # Sort all the edges in non-decreasing order of their weight
        self.graph.sort()

        # Create arrays for parent and rank of each vertex
        parent = list(range(self.V))
        rank = [0] * self.V

        # Iterate over the sorted edges
        for w, u, v in self.graph:
            # Find the sets of the vertices u and v
            root_u = self.find(parent, u)
            root_v = self.find(parent, v)

            # If including this edge doesn't cause a cycle, add it to the MST
            if root_u != root_v:
                mst.append((u, v, w))
                self.union(parent, rank, root_u, root_v)

        # Return the MST and the total weight
        total_weight = sum(w for _, _, w in mst)
        return mst, total_weight


def menu():
    while True:
        print("\nKruskal's Algorithm")
        print("1. Enter Graph Data")
        print("2. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            try:
                vertices = int(input("Enter number of vertices: "))
                g = Graph(vertices)
                num_edges = int(input("Enter number of edges: "))

                for _ in range(num_edges):
                    u, v, w = map(int, input("Enter edge (u v w): ").split())
                    if u < 0 or v < 0 or u >= vertices or v >= vertices:
                        print("Error: Vertex indices must be within the range of vertices.")
                        return
                    g.add_edge(u, v, w)

                # Running Kruskal's algorithm to find the MST
                mst, total_weight = g.kruskal_mst()

                # Display the result
                print("\nEdges in the MST:", mst)
                print("Total weight of the MST:", total_weight)
            except ValueError:
                print("Invalid input. Please enter integers only.")

        elif choice == '2':
            print("Exiting...")
            break

        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    menu()
