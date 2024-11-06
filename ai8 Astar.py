import heapq

def a_star(graph, start, end, heuristic):
 
    open_list = []
    heapq.heappush(open_list, (0, start))
    
    g_cost = {start: 0}
    f_cost = {start: heuristic[start]}
    came_from = {start: None}
    
    while open_list:
        current_priority, current_node = heapq.heappop(open_list)
        
        if current_node == end:
            path = []
            while current_node:
                path.append(current_node)
                current_node = came_from[current_node]
            return path[::-1], g_cost[end]
        
        for neighbor, weight in graph[current_node].items():
            tentative_g_cost = g_cost[current_node] + weight
            
            if neighbor not in g_cost or tentative_g_cost < g_cost[neighbor]:
                g_cost[neighbor] = tentative_g_cost
                f_cost[neighbor] = tentative_g_cost + heuristic[neighbor]
                came_from[neighbor] = current_node
                heapq.heappush(open_list, (f_cost[neighbor], neighbor))
    
    return None, float('inf')

def input_graph():
    graph = {}
    num_nodes = int(input("Enter the number of nodes: "))
    
    for i in range(num_nodes):
        node = input(f"Enter the name of node {i+1}: ").strip()
        graph[node] = {}
    
    num_edges = int(input("Enter the number of edges: "))
    
    for i in range(num_edges):
        u, v, weight = input(f"Enter edge {i+1} (format: node1 node2 weight): ").split()
        weight = int(weight)
        graph[u][v] = weight
        graph[v][u] = weight  
    
    return graph

def input_heuristic(nodes):
    heuristic = {}
    print("Enter the heuristic value for each node:")
    for node in nodes:
        heuristic[node] = int(input(f"Heuristic value for {node}: "))
    return heuristic

def main():
    graph = input_graph()
    
    nodes = graph.keys()
    
    heuristic = input_heuristic(nodes)
    
    start = input("Enter the start node: ").strip()
    end = input("Enter the end node: ").strip()
    
    if start not in graph or end not in graph:
        print("Invalid start or end node.")
        return
    
    path, cost = a_star(graph, start, end, heuristic)
    
    if path:
        print(f"Shortest path: {' -> '.join(path)}")
        print(f"Total cost: {cost}")
    else:
        print("No path found.")

if __name__ == "__main__":
    main()
