from collections import defaultdict, deque

def dfs_recursive(graph, node, traversal_type):
    visited = set()

    def _dfs_preorder(node):
        if node not in visited:
            print(node, end=' ')
            visited.add(node)
            for neighbor in graph[node]:
                _dfs_preorder(neighbor)

    def _dfs_inorder(node):
        if node not in visited:
            visited.add(node)
            if len(graph[node]) > 1:
                _dfs_inorder(graph[node][0])
            print(node, end=' ')
            if len(graph[node]) > 1:
                _dfs_inorder(graph[node][1])
            elif len(graph[node]) == 1:
                _dfs_inorder(graph[node][0])
            else:
                print(node, end=' ')

    def _dfs_postorder(node):
        if node not in visited:
            visited.add(node)
            for neighbor in graph[node]:
                _dfs_postorder(neighbor)
            print(node, end=' ')

    if traversal_type == 'preorder':
        print("DFS traversal (Preorder):")
        _dfs_preorder(node)
    elif traversal_type == 'inorder':
        print("DFS traversal (Inorder):")
        _dfs_inorder(node)
    elif traversal_type == 'postorder':
        print("DFS traversal (Postorder):")
        _dfs_postorder(node)
    else:
        print("Invalid traversal type")

def bfs_algorithm(graph, start_node):
    visited = set()
    queue = deque([start_node])
    visited.add(start_node)
    while queue:
        node = queue.popleft()
        print(node, end=' ')
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

def create_graph():
    graph = defaultdict(list)
    num_nodes = int(input("Enter the number of nodes in the graph: "))
    for _ in range(num_nodes):
        node = input("Enter the name of the node: ")
        neighbors = input(f"Enter the neighbors of {node} (comma separated): ").split(',')
        graph[node] = [neighbor.strip() for neighbor in neighbors if neighbor.strip()]
    return graph

def main():
    graph = create_graph()
    index_to_node = {i: node for i, node in enumerate(graph.keys())}

    while True:
        print("\nMenu:")
        print("1. Perform DFS")
        print("2. Perform BFS")
        print("3. Exit")

        try:
            choice = int(input("Enter your choice: "))
        except ValueError:
            print("Invalid choice. Please enter 1, 2, or 3.")
            continue

        if choice == 1:
            print("\nSelect starting node for DFS:")
            for i, node in index_to_node.items():
                print(f"{i}. {node}")

            try:
                start_node_index = int(input("Enter index of starting node: "))
                start_node = index_to_node.get(start_node_index)
                if start_node is None:
                    print("Invalid index. Please select a valid index.")
                    continue

                print("\nDFS Traversal Options:")
                print("1. Preorder")
                print("2. Inorder")
                print("3. Postorder")
                traversal_choice = int(input("Enter your choice for DFS traversal type: "))

                if traversal_choice == 1:
                    dfs_recursive(graph, start_node, 'preorder')
                    print()
                elif traversal_choice == 2:
                    dfs_recursive(graph, start_node, 'inorder')
                    print()
                elif traversal_choice == 3:
                    dfs_recursive(graph, start_node, 'postorder')
                    print()
                else:
                    print("Invalid traversal type choice. Please enter 1, 2, or 3.")
            except ValueError:
                print("Invalid input. Please enter a valid integer.")
                continue

        elif choice == 2:
            print("\nSelect starting node for BFS:")
            for i, node in index_to_node.items():
                print(f"{i}. {node}")

            try:
                start_node_index = int(input("Enter index of starting node: "))
                start_node = index_to_node.get(start_node_index)
                if start_node is None:
                    print("Invalid index. Please select a valid index.")
                    continue

                print("\nBFS traversal:")
                bfs_algorithm(graph, start_node)
                print()
            except ValueError:
                print("Invalid input. Please enter a valid integer.")
                continue

        elif choice == 3:
            print("Exiting...")
            break

        else:
            print("Invalid choice. Please enter 1, 2, or 3.")

if __name__ == "__main__":
    main()
