
print("=" * 65)
print("DAY 2 - SET 3: LOGISTICS NETWORK AND DELIVERY WINDOWS")
print("=" * 65)


# ================================================================
# TASK 1: BINARY SEARCH TREE - HUB CODES
# ================================================================

print("\nTASK 1: BINARY SEARCH TREE")


class Node:
    def __init__(self, hub_code):
        self.hub_code = hub_code
        self.left = None
        self.right = None


class BST:
    def __init__(self):
        self.root = None

    def insert(self, root, hub_code):
        if root is None:
            return Node(hub_code)

        if hub_code < root.hub_code:
            root.left = self.insert(root.left, hub_code)

        elif hub_code > root.hub_code:
            root.right = self.insert(root.right, hub_code)

        return root

    def search(self, root, hub_code):
        if root is None or root.hub_code == hub_code:
            return root

        if hub_code < root.hub_code:
            return self.search(root.left, hub_code)

        return self.search(root.right, hub_code)

    def inorder(self, root):
        if root:
            self.inorder(root.left)
            print(root.hub_code, end=" ")
            self.inorder(root.right)

    def height(self, root):
        if root is None:
            return 0

        left_height = self.height(root.left)
        right_height = self.height(root.right)

        return 1 + max(left_height, right_height)


# Insert hub codes

hub_codes = [
    "H50", "H30", "H70", "H20", "H40",
    "H60", "H80", "H10", "H35", "H90"
]

bst = BST()

for hub in hub_codes:
    bst.root = bst.insert(bst.root, hub)

print("Hub Codes Inserted Successfully:", len(hub_codes))

print("\nInorder Traversal:")
bst.inorder(bst.root)

# Search hub

search_hub = "H60"

if bst.search(bst.root, search_hub):
    print("\n\nHub Found:", search_hub)
else:
    print("\n\nHub Not Found:", search_hub)

print("BST Height:", bst.height(bst.root), "Levels")


# Demonstrate sorted input effect

sorted_bst = BST()

sorted_hubs = sorted(hub_codes)

for hub in sorted_hubs:
    sorted_bst.root = sorted_bst.insert(
        sorted_bst.root, hub
    )

print("Height with Sorted Input:",
      sorted_bst.height(sorted_bst.root), "Levels")

print("Explanation: Sorted input creates a skewed BST,")
print("increasing height and making search slower.")


# Empty tree test

empty_bst = BST()

print("Empty BST Height:", empty_bst.height(empty_bst.root))


# ================================================================
# TASK 2: HASH MAP - PARCEL TRACKING AND DUPLICATE SCANS
# ================================================================

print("\n\nTASK 2: HASH MAP AND DUPLICATE PARCEL DETECTION")


# Hash map stores tracking number and hub scans

parcel_map = {}

parcel_scans = [
    ("TRK101", "Chennai"),
    ("TRK102", "Bangalore"),
    ("TRK103", "Mumbai"),
    ("TRK104", "Delhi"),
    ("TRK101", "Chennai"),
    ("TRK105", "Hyderabad"),
    ("TRK102", "Bangalore"),
    ("TRK106", "Kochi"),
    ("TRK107", "Pune"),
    ("TRK108", "Chennai")
]


for tracking_id, hub in parcel_scans:

    if tracking_id not in parcel_map:
        parcel_map[tracking_id] = []

    parcel_map[tracking_id].append(hub)


print("Parcel Tracking Lookup:")

search_tracking = "TRK103"

if search_tracking in parcel_map:
    print(search_tracking, "found at:",
          parcel_map[search_tracking])
else:
    print(search_tracking, "not found")


# Duplicate scan detection

print("\nDuplicate Parcel Scans:")

duplicate_found = False

for tracking_id, hubs in parcel_map.items():

    for hub in set(hubs):

        if hubs.count(hub) > 1:
            print("Duplicate:", tracking_id,
                  "scanned multiple times at", hub)

            duplicate_found = True

if not duplicate_found:
    print("No duplicate scans found.")


print("\nTotal Unique Parcels:", len(parcel_map))

# Empty lookup test

print("Empty Lookup Test:",
      parcel_map.get("TRK999", "Parcel Not Found"))


# ================================================================
# TASK 3: GRAPH - HUB NETWORK, BFS AND DFS
# ================================================================

print("\n\nTASK 3: LOGISTICS NETWORK GRAPH")


# 10 hubs and their direct routes

graph = {
    "Chennai": ["Bangalore", "Hyderabad"],
    "Bangalore": ["Chennai", "Kochi", "Mumbai"],
    "Hyderabad": ["Chennai", "Pune", "Delhi"],
    "Kochi": ["Bangalore", "Mumbai"],
    "Mumbai": ["Bangalore", "Kochi", "Delhi"],
    "Pune": ["Hyderabad", "Delhi"],
    "Delhi": ["Hyderabad", "Mumbai", "Kolkata"],
    "Kolkata": ["Delhi", "Patna"],
    "Patna": ["Kolkata", "Lucknow"],
    "Lucknow": ["Patna"]
}


print("Total Hubs:", len(graph))

print("\nAdjacency List:")

for hub, routes in graph.items():
    print(hub, "->", routes)


# BFS - SHORTEST ROUTE

def bfs_shortest_path(graph, start, destination):

    if start not in graph or destination not in graph:
        return None

    queue = [[start]]
    visited = {start}

    while queue:

        path = queue.pop(0)
        current = path[-1]

        if current == destination:
            return path

        for neighbor in graph[current]:

            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(path + [neighbor])

    return None


start_hub = "Chennai"
destination_hub = "Delhi"

shortest_route = bfs_shortest_path(
    graph, start_hub, destination_hub
)

print("\nBFS Shortest Route:")
print(shortest_route)

if shortest_route:
    print("Minimum Hops:", len(shortest_route) - 1)


# DFS - FIND ALL REACHABLE HUBS

def dfs_reachable(graph, start):

    if start not in graph:
        return []

    visited = set()
    stack = [start]
    result = []

    while stack:

        current = stack.pop()

        if current not in visited:

            visited.add(current)
            result.append(current)

            for neighbor in reversed(graph[current]):

                if neighbor not in visited:
                    stack.append(neighbor)

    return result


print("\nDFS - Hubs Reachable From Central Depot:")

reachable = dfs_reachable(graph, "Chennai")

print(reachable)

print("Total Reachable Hubs:", len(reachable))


# Empty graph test

print("\nEmpty Graph Test:",
      bfs_shortest_path({}, "Chennai", "Delhi"))


# ================================================================
# TASK 4: SLIDING WINDOW - HIGHEST AVERAGE PARCEL COUNT
# ================================================================

print("\n\nTASK 4: SLIDING WINDOW")


# Daily parcel counts for 10 days

daily_parcels = [
    120, 150, 180, 200, 250,
    300, 280, 350, 400, 320
]


def highest_average_window(arr, window_size):

    if window_size <= 0 or window_size > len(arr):
        return None

    # Calculate first window sum

    window_sum = sum(arr[:window_size])

    max_sum = window_sum
    best_start = 0

    # Slide the window

    for i in range(window_size, len(arr)):

        window_sum += arr[i]
        window_sum -= arr[i - window_size]

        if window_sum > max_sum:
            max_sum = window_sum
            best_start = i - window_size + 1

    average = max_sum / window_size

    return best_start, max_sum, average


window_size = 3

result = highest_average_window(
    daily_parcels, window_size
)

print("Daily Parcel Counts:", daily_parcels)

print("Window Size:", window_size, "Days")

if result:

    start_index, total, average = result

    print("Best Window: Day",
          start_index + 1, "to Day",
          start_index + window_size)

    print("Total Parcels:", total)

    print("Highest Average:", round(average, 2))


# Empty input test

print("\nEmpty Input Test:",
      highest_average_window([], 3))


# ================================================================
# TASK 5: TWO POINTERS - PALINDROME ROUTE CHECK
# ================================================================

print("\n\nTASK 5: TWO POINTERS - PALINDROME CHECK")


def is_palindrome(route):

    # Ignore case and separators

    cleaned = "".join(
        char.lower()
        for char in route
        if char.isalnum()
    )

    left = 0
    right = len(cleaned) - 1

    while left < right:

        if cleaned[left] != cleaned[right]:
            return False

        left += 1
        right -= 1

    return True


# Test routes

routes = [
    "ABBA",
    "A-B-B-A",
    "Chennai-Bangalore-Chennai",
    "Madam",
    "Delhi-Mumbai-Delhi"
]


for route in routes:

    print("\nRoute:", route)

    if is_palindrome(route):
        print("Result: Palindrome")
    else:
        print("Result: Not a Palindrome")


# Empty input test

print("\nEmpty Route Test:",
      is_palindrome(""))


# ================================================================
# FINAL COMPLEXITY TABLE
# ================================================================

print("\n\n" + "=" * 65)
print("FINAL COMPLEXITY TABLE")
print("=" * 65)

print("""
1. BINARY SEARCH TREE
   Insertion: Average O(log n), Worst O(n)
   Search:    Average O(log n), Worst O(n)
   Height:    O(n)
   Space:     O(n)

2. HASH MAP
   Insert:    Average O(1), Worst O(n)
   Lookup:    Average O(1), Worst O(n)
   Duplicate detection:
              O(n) average for this implementation
   Space:     O(n)

3. GRAPH
   BFS:       O(V + E)
   DFS:       O(V + E)
   Space:     O(V + E)

4. SLIDING WINDOW
   Time:      O(n)
   Space:     O(1)

5. TWO POINTERS
   Time:      O(n)
   Space:     O(n) for normalized route string
""")

print("=" * 65)
print("ALL 5 TASKS COMPLETED SUCCESSFULLY!")
print("=" * 65)
