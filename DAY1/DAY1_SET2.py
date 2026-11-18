import csv
import time
from datetime import datetime, timedelta

# --- Data Model ---
class Transaction:
    def __init__(self, tx_id, account_id, amount, merchant, timestamp):
        self.tx_id = int(tx_id)
        self.account_id = account_id
        self.amount = float(amount)
        self.merchant = merchant
        self.timestamp = timestamp  # string or datetime

    def __lt__(self, other):
        return self.tx_id < other.tx_id

def load_transactions(filepath):
    transactions = []
    with open(filepath, mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            transactions.append(Transaction(
                row['tx_id'], 
                row['account_id'], 
                row['amount'], 
                row['merchant'], 
                row['timestamp']
            ))
    return transactions

print("Loading transactions.csv...")
txs = load_transactions('transactions.csv')
print(f"Successfully loaded {len(txs)} transactions!\n")


# =====================================================================
# TASK 1: Search & Comparison (Binary Search vs. Linear Search)
# =====================================================================
print("=" * 50)
print("TASK 1: Binary Search with Comparisons vs. Linear Search")
print("=" * 50)

def binary_search_counted(arr, target_id):
    low, high = 0, len(arr) - 1
    comparisons = 0
    while low <= high:
        comparisons += 1
        mid = (low + high) // 2
        if arr[mid].tx_id == target_id:
            return mid, comparisons
        elif arr[mid].tx_id < target_id:
            low = mid + 1
        else:
            high = mid - 1
    return -1, comparisons

def linear_search_counted(arr, target_id):
    comparisons = 0
    for i, tx in enumerate(arr):
        comparisons += 1
        if tx.tx_id == target_id:
            return i, comparisons
    return -1, comparisons

# Ensure sorted for binary search
txs.sort()

# Best case: Middle element
mid_idx = len(txs) // 2
target_best = txs[mid_idx].tx_id
_, b_comp = binary_search_counted(txs, target_best)

# Worst case: Element at the end or non-existent
target_worst = txs[-1].tx_id
_, w_comp = binary_search_counted(txs, target_worst)

_, l_comp = linear_search_counted(txs, target_worst)

print(f"Binary Search Best Case Comparisons: {b_comp}")
print(f"Binary Search Worst Case Comparisons: {w_comp}")
print(f"Linear Search Worst Case Comparisons: {l_comp}\n")


# =====================================================================
# TASK 2: Sorting & Stability (Insertion Sort vs. Merge Sort)
# =====================================================================
print("=" * 50)
print("TASK 2: Sorting by Posting Date (Insertion & Merge Sort)")
print("=" * 50)

# Filter a subset of transactions for a specific customer to demonstrate sorting
sample_customer = txs[0].account_id
customer_txs = [t for t in txs if t.account_id == sample_customer][:15] # Small subset for demo

def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        # Stable sort condition: preserve relative order for equal timestamps
        while j >= 0 and arr[j].timestamp > key.timestamp:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key

def merge_sort_timestamp(arr):
    if len(arr) > 1:
        mid = len(arr) // 2
        left = arr[:mid]
        right = arr[mid:]

        merge_sort_timestamp(left)
        merge_sort_timestamp(right)

        i = j = k = 0
        while i < len(left) and j < len(right):
            # Using >= ensures stability
            if left[i].timestamp <= right[j].timestamp:
                arr[k] = left[i]
                i += 1
            else:
                arr[k] = right[j]
                j += 1
            k += 1

        while i < len(left):
            arr[k] = left[i]
            i += 1
            k += 1
        while j < len(right):
            arr[k] = right[j]
            j += 1
            k += 1

demo_txs = list(customer_txs)
merge_sort_timestamp(demo_txs)
print(f"Sorted {len(demo_txs)} transactions for customer {sample_customer} by timestamp using Merge Sort.")
print("Note on Stability: Stable sorting ensures that if two transactions occur at the exact same timestamp, their original ingestion order is preserved.\n")


# =====================================================================
# TASK 3: Duplicate Postings Identification
# =====================================================================
print("=" * 50)
print("TASK 3: Duplicate Postings Identification (Within 60s)")
print("=" * 50)

def find_duplicate_postings(transactions):
    # Group by account_id and merchant and amount to efficiently check time windows
    duplicates = []
    seen = {} # key: (account_id, amount, merchant), value: list of timestamps
    
    for tx in transactions:
        key = (tx.account_id, tx.amount, tx.merchant)
        tx_time = datetime.strptime(tx.timestamp, "%Y-%m-%d %H:%M:%S")
        
        if key in seen:
            for prev_time, prev_tx in seen[key]:
                if abs((tx_time - prev_time).total_seconds()) <= 60:
                    duplicates.append((prev_tx, tx))
        else:
            seen[key] = []
        seen[key].append((tx_time, tx))
        
    return duplicates

dupes = find_duplicate_postings(txs)
print(f"Identified {len(dupes)} duplicate posting pair(s) within a 60-second window.")
if dupes:
    print(f"Sample Duplicate: Account {dupes[0][0].account_id}, Amount ${dupes[0][0].amount} at {dupes[0][0].timestamp} and {dupes[0][1].timestamp}\n")


# =====================================================================
# TASK 4: Custom Queue & Stack (No Library Collections)
# =====================================================================
print("=" * 50)
print("TASK 4: Custom Queue (Backlog) & Stack (Adjustments)")
print("=" * 50)

class CustomQueue:
    def __init__(self):
        self.items = []
    def enqueue(self, item):
        self.items.insert(0, item)  # FIFO: insert at front
    def dequeue(self):
        return self.items.pop() if self.items else None
    def is_empty(self):
        return len(self.items) == 0

class CustomStack:
    def __init__(self):
        self.items = []
    def push(self, item):
        self.items.append(item)     # LIFO: push to end
    def pop(self):
        return self.items.pop() if self.items else None
    def is_empty(self):
        return len(self.items) == 0

# Test Stack & Queue
backlog_queue = CustomQueue()
backlog_queue.enqueue("Review Tx #1000001")
print("Queue Dequeue (Manual Review Backlog):", backlog_queue.dequeue())

adjustment_stack = CustomStack()
adjustment_stack.push("Adjustment: Reverse Tx #1000002")
print("Stack Pop (Reverse Last Adjustment):", adjustment_stack.pop())
print()


# =====================================================================
# TASK 5: Divide-and-Conquer vs. Brute-Force Min/Max
# =====================================================================
print("=" * 50)
print("TASK 5: Divide-and-Conquer vs. Brute-Force Min/Max")
print("=" * 50)

def find_min_max_dc(arr, low, high):
    if low == high:
        return arr[low].amount, arr[low].amount
    if high == low + 1:
        if arr[low].amount < arr[high].amount:
            return arr[low].amount, arr[high].amount
        return arr[high].amount, arr[low].amount

    mid = (low + high) // 2
    min1, max1 = find_min_max_dc(arr, low, mid)
    min2, max2 = find_min_max_dc(arr, mid + 1, high)

    return min(min1, min2), max(max1, max2)

def find_min_max_brute(arr):
    min_val = arr[0].amount
    max_val = arr[0].amount
    for tx in arr[1:]:
        if tx.amount < min_val:
            min_val = tx.amount
        if tx.amount > max_val:
            max_val = tx.amount
    return min_val, max_val

start = time.perf_counter_ns()
dc_min, dc_max = find_min_max_dc(txs, 0, len(txs) - 1)
dc_time = time.perf_counter_ns() - start

start = time.perf_counter_ns()
bf_min, bf_max = find_min_max_brute(txs)
bf_time = time.perf_counter_ns() - start

print(f"Divide-and-Conquer Result -> Min: ${dc_min}, Max: ${dc_max} (Time: {dc_time} ns)")
print(f"Brute-Force Result         -> Min: ${bf_min}, Max: ${bf_max} (Time: {bf_time} ns)")
print("\nAll tasks completed successfully!")