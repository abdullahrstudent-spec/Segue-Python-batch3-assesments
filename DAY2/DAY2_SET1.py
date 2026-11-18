
import time

print("=" * 65)
print("DAY 2 - E-COMMERCE CATALOGUE AND TRAFFIC ANALYSIS")
print("=" * 65)



print("\nTASK 1: BINARY SEARCH TREE")

class Node:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None


class BST:
    def __init__(self):
        self.root = None

    def insert(self, root, data):
        if root is None:
            return Node(data)

        if data < root.data:
            root.left = self.insert(root.left, data)
        elif data > root.data:
            root.right = self.insert(root.right, data)

        return root

    def search(self, root, key):
        if root is None or root.data == key:
            return root

        if key < root.data:
            return self.search(root.left, key)

        return self.search(root.right, key)

    def inorder(self, root):
        if root:
            self.inorder(root.left)
            print(root.data, end=" ")
            self.inorder(root.right)

    def preorder(self, root):
        if root:
            print(root.data, end=" ")
            self.preorder(root.left)
            self.preorder(root.right)

    def postorder(self, root):
        if root:
            self.postorder(root.left)
            self.postorder(root.right)
            print(root.data, end=" ")


bst = BST()

categories = [
    "Electronics", "Clothing", "Books", "Furniture",
    "Groceries", "Mobiles", "Laptops", "Shoes",
    "Watches", "Beauty", "Sports", "Toys",
    "Kitchen", "Gaming", "Accessories"
]

for category in categories:
    bst.root = bst.insert(bst.root, category)

print("15 Categories Inserted Successfully")

print("Inorder Traversal:")
bst.inorder(bst.root)

print("\nPreorder Traversal:")
bst.preorder(bst.root)

print("\nPostorder Traversal:")
bst.postorder(bst.root)

search_category = "Mobiles"

if bst.search(bst.root, search_category):
    print("\n\nCategory Found:", search_category)
else:
    print("\n\nCategory Not Found")


# ================================================================
# TASK 2: HASH TABLE WITH CHAINING AND BUILT-IN DICTIONARY
# ================================================================

print("\n\nTASK 2: HASHING AND HASH MAPS")


class HashTable:
    def __init__(self, size):
        self.size = size
        self.table = [[] for _ in range(size)]

    def hash_function(self, key):
        hash_value = 0

        for char in key:
            hash_value = (hash_value * 31 + ord(char)) % self.size

        return hash_value

    def insert(self, key, value):
        index = self.hash_function(key)

        for i, (old_key, old_value) in enumerate(self.table[index]):
            if old_key == key:
                self.table[index][i] = (key, value)
                return

        self.table[index].append((key, value))

    def search(self, key):
        index = self.hash_function(key)

        for old_key, value in self.table[index]:
            if old_key == key:
                return value

        return None


# Demonstrate collision using two different keys
small_table = HashTable(10)

small_table.insert("AB", "Product 1")
small_table.insert("BA", "Product 2")

print("Collision Demonstration:")
print("AB Hash Index:", small_table.hash_function("AB"))
print("BA Hash Index:", small_table.hash_function("BA"))
print("AB Lookup:", small_table.search("AB"))
print("BA Lookup:", small_table.search("BA"))
print("Both keys are stored in the same bucket using chaining.")


# Create 100,000 SKUs
print("\nComparing lookup time for 100,000 SKUs...")

sku_count = 100000

custom_table = HashTable(200003)
builtin_map = {}

for i in range(sku_count):
    sku = "SKU" + str(i)
    value = "Product" + str(i)

    custom_table.insert(sku, value)
    builtin_map[sku] = value


# Prepare lookup queries
queries = ["SKU" + str(i) for i in range(sku_count)]


# Custom Hash Table Lookup
start = time.perf_counter()

for sku in queries:
    custom_table.search(sku)

custom_time = time.perf_counter() - start


# Built-in Dictionary Lookup
start = time.perf_counter()

for sku in queries:
    builtin_map.get(sku)

builtin_time = time.perf_counter() - start


print("Total SKUs:", sku_count)
print("Custom Hash Table Lookup Time:", custom_time, "seconds")
print("Built-in Dictionary Lookup Time:", builtin_time, "seconds")


# ================================================================
# TASK 3: GRAPH - BFS, DFS AND CYCLE DETECTION
# ================================================================

print("\n\nTASK 3: MICROSERVICE DEPLOYMENT GRAPH")


graph = {
    "Cart": ["Pricing"],
    "Pricing": ["Inventory"],
    "Inventory": ["Payment"],
    "Payment": ["Shipping"],
    "Shipping": ["Notification"],
    "Notification": []
}


# BFS Traversal
def bfs(graph, start):
    visited = set()
    queue = [start]
    visited.add(start)

    order = []

    while queue:
        node = queue.pop(0)
        order.append(node)

        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    return order


# DFS Traversal
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()

    visited.add(node)
    print(node, end=" ")

    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)


# Topological Sorting using BFS (Kahn's Algorithm)
def topological_sort(graph):
    indegree = {node: 0 for node in graph}

    for node in graph:
        for neighbor in graph[node]:
            indegree[neighbor] += 1

    queue = [node for node in graph if indegree[node] == 0]
    order = []

    while queue:
        node = queue.pop(0)
        order.append(node)

        for neighbor in graph[node]:
            indegree[neighbor] -= 1

            if indegree[neighbor] == 0:
                queue.append(neighbor)

    if len(order) != len(graph):
        return None

    return order


# Cycle Detection using DFS
def detect_cycle(graph):
    visited = set()
    active = set()

    def dfs_cycle(node):
        visited.add(node)
        active.add(node)

        for neighbor in graph[node]:
            if neighbor not in visited:
                if dfs_cycle(neighbor):
                    return True
            elif neighbor in active:
                return True

        active.remove(node)
        return False

    for node in graph:
        if node not in visited:
            if dfs_cycle(node):
                return True

    return False


print("BFS Traversal:")
print(bfs(graph, "Cart"))

print("DFS Traversal:")
dfs(graph, "Cart")

print("\nDeployment Order:")
print(topological_sort(graph))

print("Circular Dependency:", detect_cycle(graph))


# Introduce a circular dependency
cyclic_graph = {
    "Cart": ["Pricing"],
    "Pricing": ["Inventory"],
    "Inventory": ["Payment"],
    "Payment": ["Cart"]
}

print("\nAfter Adding Circular Dependency:")
print("Circular Dependency:", detect_cycle(cyclic_graph))
print("Deployment Order:", topological_sort(cyclic_graph))


# ================================================================
# TASK 4: SLIDING WINDOW - BUSIEST CONTINUOUS 3 HOURS
# ================================================================

print("\n\nTASK 4: SLIDING WINDOW")

requests = [
    120, 150, 180, 200, 250, 300,
    350, 400, 450, 500, 550, 600,
    650, 700, 750, 800, 850, 900,
    950, 1000, 1050, 1100, 1150, 1200
]


def busiest_window(arr):
    window_size = 3

    current_sum = sum(arr[:window_size])
    max_sum = current_sum
    best_start = 0

    for i in range(window_size, len(arr)):
        current_sum += arr[i] - arr[i - window_size]

        if current_sum > max_sum:
            max_sum = current_sum
            best_start = i - window_size + 1

    return best_start, max_sum


start_hour, total_requests = busiest_window(requests)

print("Total Hours:", len(requests))
print("Window Duration: 3 Hours")
print("Busiest Window: Hour", start_hour + 1,
      "to Hour", start_hour + 3)
print("Total Requests:", total_requests)
print("Average Requests Per Minute:",
      total_requests / (3 * 60))


# ================================================================
# TASK 5: TWO POINTERS - GIFT CARD PAIR SUM
# ================================================================

print("\n\nTASK 5: TWO POINTERS")

order_values = [
    100, 200, 300, 400, 500,
    600, 700, 800, 900, 1000
]

gift_card_value = 1000


def find_pairs(arr, target):
    left = 0
    right = len(arr) - 1

    pairs = []

    while left < right:

        current_sum = arr[left] + arr[right]

        if current_sum == target:
            pairs.append((arr[left], arr[right]))
            left += 1
            right -= 1

        elif current_sum < target:
            left += 1

        else:
            right -= 1

    return pairs


pairs = find_pairs(order_values, gift_card_value)

print("Order Values:", order_values)
print("Gift Card Value:", gift_card_value)
print("Matching Pairs:")

for pair in pairs:
    print(pair)


# ================================================================
# FINAL DECISION TABLE
# ================================================================

print("\n\n" + "=" * 65)
print("FINAL DECISION TABLE")
print("=" * 65)

print("""
1. BST:
   Problem: Product Category Searching
   Structure: Binary Search Tree
   Reason: Efficient insertion and searching.

2. Hashing:
   Problem: SKU Lookup
   Structure: Hash Table with Chaining / Dictionary
   Reason: Fast average O(1) lookup.

3. Graph:
   Problem: Microservice Dependencies
   Structure: Directed Graph
   Reason: BFS/DFS traversal, deployment ordering
   and cycle detection.

4. Sliding Window:
   Problem: Busiest 3-Hour Traffic
   Pattern: Sliding Window
   Reason: Avoids recalculating every 3-hour sum.

5. Two Pointers:
   Problem: Gift Card Pair Sum
   Pattern: Two Pointers
   Reason: Finds matching pairs in a sorted list
   without nested loops.
""")

print("=" * 65)
print("ALL 5 TASKS COMPLETED SUCCESSFULLY!")
print("=" * 65)
