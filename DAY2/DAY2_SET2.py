
print("=" * 65)
print("DAY 2 - INSURANCE CLAIMS PROCESSING")
print("=" * 65)


# ================================================================
# TASK 1: BINARY SEARCH TREE - CLAIM ID INSERTION AND SEARCH
# ================================================================

print("\nTASK 1: BINARY SEARCH TREE")


class Node:
    def __init__(self, claim_id):
        self.claim_id = claim_id
        self.left = None
        self.right = None


class BST:
    def __init__(self):
        self.root = None

    def insert(self, root, claim_id):
        if root is None:
            return Node(claim_id)

        if claim_id < root.claim_id:
            root.left = self.insert(root.left, claim_id)

        elif claim_id > root.claim_id:
            root.right = self.insert(root.right, claim_id)

        return root

    def search(self, root, claim_id):
        if root is None or root.claim_id == claim_id:
            return root

        if claim_id < root.claim_id:
            return self.search(root.left, claim_id)

        return self.search(root.right, claim_id)

    def inorder(self, root):
        if root:
            self.inorder(root.left)
            print(root.claim_id, end=" ")
            self.inorder(root.right)

    def preorder(self, root):
        if root:
            print(root.claim_id, end=" ")
            self.preorder(root.left)
            self.preorder(root.right)

    def postorder(self, root):
        if root:
            self.postorder(root.left)
            self.postorder(root.right)
            print(root.claim_id, end=" ")


bst = BST()

claim_ids = [105, 102, 108, 101, 104, 107, 110,
             103, 106, 109, 115, 112, 111, 114, 113]

for claim in claim_ids:
    bst.root = bst.insert(bst.root, claim)

print("15 Claim IDs Inserted Successfully")

print("\nInorder Traversal:")
bst.inorder(bst.root)

print("\nPreorder Traversal:")
bst.preorder(bst.root)

print("\nPostorder Traversal:")
bst.postorder(bst.root)

search_id = 107

if bst.search(bst.root, search_id):
    print("\n\nClaim Found:", search_id)
else:
    print("\n\nClaim Not Found:", search_id)

# Empty input test
empty_bst = BST()

print("\nEmpty BST Search:",
      empty_bst.search(empty_bst.root, 100))


# ================================================================
# TASK 2: HASHING - DUPLICATE CLAIM DETECTION
# ================================================================

print("\n\nTASK 2: HASHING AND DUPLICATE CLAIM DETECTION")


class HashTable:
    def __init__(self, size):
        self.size = size
        self.table = [[] for _ in range(size)]

    def normalize(self, value):
        return "".join(value.lower().split())

    def hash_function(self, key):
        policy, incident_date = key

        text = policy + incident_date
        hash_value = 0

        for char in text:
            hash_value = (
                hash_value * 31 + ord(char)
            ) % self.size

        return hash_value

    def insert(self, policy, incident_date, claim_id):
        key = (
            self.normalize(policy),
            self.normalize(incident_date)
        )

        index = self.hash_function(key)

        for existing_key, existing_claims in self.table[index]:
            if existing_key == key:
                existing_claims.append(claim_id)
                return

        self.table[index].append((key, [claim_id]))

    def search(self, policy, incident_date):
        key = (
            self.normalize(policy),
            self.normalize(incident_date)
        )

        index = self.hash_function(key)

        for existing_key, claims in self.table[index]:
            if existing_key == key:
                return claims

        return []


claims = [
    (101, "POL123", "2026-11-10"),
    (102, "pol123", "2026-11-10"),
    (103, "POL456", "2026-11-11"),
    (104, " POL 123 ", "2026-11-10"),
    (105, "POL789", "2026-11-12"),
    (106, "pol456", "2026-11-11")
]

hash_table = HashTable(10)

for claim_id, policy, incident_date in claims:
    hash_table.insert(policy, incident_date, claim_id)

print("Duplicate Claims:")

for claim_id, policy, incident_date in claims:
    matching = hash_table.search(policy, incident_date)

    if len(matching) > 1:
        print("Claim ID:", claim_id,
              "Matching Claims:", matching)

# Collision demonstration
print("\nCollision Demonstration:")

key1 = ("AB", "2026-11-10")
key2 = ("BA", "2026-11-10")

index1 = hash_table.hash_function(key1)
index2 = hash_table.hash_function(key2)

print("Hash Index 1:", index1)
print("Hash Index 2:", index2)

if index1 == index2:
    print("Collision Detected!")
    print("Collision handled using Chaining.")

# Empty input test
empty_hash = HashTable(10)

print("\nEmpty Hash Search:",
      empty_hash.search("POL999", "2026-11-10"))


# ================================================================
# TASK 3: GRAPH - BFS SHORTEST PATH AND DFS LOOP DETECTION
# ================================================================

print("\n\nTASK 3: CLAIM APPROVAL GRAPH")


graph = {
    "Registration": ["Assessment"],
    "Assessment": ["Surveyor", "Settlement"],
    "Surveyor": ["Settlement"],
    "Settlement": []
}


# BFS - SHORTEST PATH

def bfs_shortest_path(graph, start, target):

    if start not in graph or target not in graph:
        return None

    queue = [[start]]
    visited = {start}

    while queue:

        path = queue.pop(0)
        current = path[-1]

        if current == target:
            return path

        for neighbor in graph[current]:

            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(path + [neighbor])

    return None


# DFS - CYCLE DETECTION

def detect_cycle(graph):

    visited = set()
    active = set()

    def dfs(node):

        visited.add(node)
        active.add(node)

        for neighbor in graph[node]:

            if neighbor not in visited:
                if dfs(neighbor):
                    return True

            elif neighbor in active:
                return True

        active.remove(node)
        return False

    for node in graph:

        if node not in visited:
            if dfs(node):
                return True

    return False


print("Approval Stages:")
for stage, next_stages in graph.items():
    print(stage, "->", next_stages)

path = bfs_shortest_path(
    graph, "Registration", "Settlement"
)

print("\nShortest Approval Path:")
print(path)

print("Circular Dependency:", detect_cycle(graph))


# Introduce a loop for testing

cyclic_graph = {
    "Registration": ["Assessment"],
    "Assessment": ["Surveyor"],
    "Surveyor": ["Settlement"],
    "Settlement": ["Registration"]
}

print("\nAfter Introducing Circular Dependency:")
print("Circular Dependency:",
      detect_cycle(cyclic_graph))


# Empty graph test
print("Empty Graph Cycle Test:",
      detect_cycle({}))


# ================================================================
# TASK 4: SLIDING WINDOW - CONSECUTIVE DAYS WITH MORE THAN 100 CLAIMS
# ================================================================

print("\n\nTASK 4: SLIDING WINDOW")


daily_claims = [
    80, 120, 130, 150, 110, 90,
    140, 160, 170, 180, 190, 80,
    120, 130, 140, 150, 160, 170,
    90, 100, 110, 120, 130, 140
]


def longest_claim_run(arr):

    max_length = 0
    current_length = 0
    best_start = -1
    current_start = -1

    for i in range(len(arr)):

        if arr[i] > 100:

            if current_length == 0:
                current_start = i

            current_length += 1

            if current_length > max_length:
                max_length = current_length
                best_start = current_start

        else:
            current_length = 0

    return best_start, max_length


start_day, longest_run = longest_claim_run(daily_claims)

print("Total Days:", len(daily_claims))

if longest_run > 0:
    print("Longest Consecutive Run:", longest_run, "Days")
    print("Starting Day:", start_day + 1)
    print("Ending Day:", start_day + longest_run)
else:
    print("No days exceeded 100 claims.")

# Empty input test
print("\nEmpty Input Test:",
      longest_claim_run([]))


# ================================================================
# TASK 5: TWO POINTERS - MERGE TWO SORTED CLAIM LISTS
# ================================================================

print("\n\nTASK 5: TWO POINTERS")


regional_office_1 = [
    101, 103, 105, 107, 109, 111
]

regional_office_2 = [
    102, 104, 106, 108, 110, 112
]


def merge_claims(arr1, arr2):

    i = 0
    j = 0

    merged = []

    while i < len(arr1) and j < len(arr2):

        if arr1[i] <= arr2[j]:
            merged.append(arr1[i])
            i += 1

        else:
            merged.append(arr2[j])
            j += 1

    # Add remaining elements

    while i < len(arr1):
        merged.append(arr1[i])
        i += 1

    while j < len(arr2):
        merged.append(arr2[j])
        j += 1

    return merged


merged_claims = merge_claims(
    regional_office_1,
    regional_office_2
)

print("Regional Office 1:", regional_office_1)
print("Regional Office 2:", regional_office_2)

print("\nMerged Sorted Claim List:")
print(merged_claims)


# Duplicate test
print("\nDuplicate Test:")

print(merge_claims(
    [101, 102, 102, 105],
    [102, 103, 105, 105]
))

# Empty input test
print("\nEmpty Input Test:")
print(merge_claims([], [101, 102, 103]))


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
   Traversal: O(n)
   Space:     O(n)

2. HASHING
   Insertion: Average O(1), Worst O(n)
   Search:    Average O(1), Worst O(n)
   Space:     O(n)

3. GRAPH
   BFS:       O(V + E)
   DFS:       O(V + E)
   Space:     O(V + E)

4. SLIDING WINDOW
   Time:      O(n)
   Space:     O(1)

5. TWO POINTERS
   Time:      O(n + m)
   Space:     O(n + m)
   (Output list requires additional space.)
""")

print("=" * 65)
print("ALL 5 TASKS COMPLETED SUCCESSFULLY!")
print("=" * 65)
