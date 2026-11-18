
import csv
import time
from datetime import datetime
from collections import deque



# Load orders.csv
def load_orders():
    with open("orders.csv", "r", newline="") as file:
        reader = csv.DictReader(file)
        orders = []

        for row in reader:
            row["amount"] = float(row["amount"])
            orders.append(row)

    return orders


orders = load_orders()

print("Total Orders Loaded:", len(orders))



def linear_search(orders, order_id):
    for order in orders:
        if order["orderId"] == order_id:
            return order
    return None


def binary_search(orders, order_id):
    low = 0
    high = len(orders) - 1

    while low <= high:
        mid = (low + high) // 2

        if orders[mid]["orderId"] == order_id:
            return orders[mid]

        elif orders[mid]["orderId"] < order_id:
            low = mid + 1

        else:
            high = mid - 1

    return None


print("\n========== TASK 1 ==========")

target_id = orders[0]["orderId"]

start = time.perf_counter()
result = linear_search(orders, target_id)
linear_time = time.perf_counter() - start

print("Linear Search Result:", result)
print("Linear Search Time:", linear_time)

sorted_orders = sorted(orders, key=lambda x: x["orderId"])

start = time.perf_counter()
result = binary_search(sorted_orders, target_id)
binary_time = time.perf_counter() - start

print("Binary Search Result:", result)
print("Binary Search Time:", binary_time)

print("Linear Search Complexity: O(n)")
print("Binary Search Complexity: O(log n)")
print("Binary search requires sorted data.")




def selection_sort(data):
    arr = data.copy()
    n = len(arr)

    for i in range(n):
        max_index = i

        for j in range(i + 1, n):
            if arr[j]["amount"] > arr[max_index]["amount"]:
                max_index = j

        arr[i], arr[max_index] = arr[max_index], arr[i]

    return arr


def merge_sort(data):
    if len(data) <= 1:
        return data

    mid = len(data) // 2

    left = merge_sort(data[:mid])
    right = merge_sort(data[mid:])

    return merge(left, right)


def merge(left, right):
    result = []

    i = 0
    j = 0

    while i < len(left) and j < len(right):

        if left[i]["amount"] >= right[j]["amount"]:
            result.append(left[i])
            i += 1

        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])

    return result



# Trace first three passes using sample data
sample = orders[:8].copy()

print("\nSelection Sort - First Three Passes:")

trace = sample.copy()

for i in range(min(3, len(trace))):
    max_index = i

    for j in range(i + 1, len(trace)):
        if trace[j]["amount"] > trace[max_index]["amount"]:
            max_index = j

    trace[i], trace[max_index] = trace[max_index], trace[i]

    print("Pass", i + 1,
          [x["amount"] for x in trace])


# Benchmark on 10,000 records
test_data = orders[:10000]

start = time.perf_counter()
selection_result = selection_sort(test_data)
selection_time = time.perf_counter() - start

start = time.perf_counter()
merge_result = merge_sort(test_data)
merge_time = time.perf_counter() - start

start = time.perf_counter()
builtin_result = sorted(
    test_data,
    key=lambda x: x["amount"],
    reverse=True
)
builtin_time = time.perf_counter() - start

print("\nSorting Benchmark (10,000 Orders)")

print("Selection Sort:", round(selection_time, 6), "seconds")
print("Merge Sort:", round(merge_time, 6), "seconds")
print("Built-in Sort:", round(builtin_time, 6), "seconds")

print("\nTop 5 Orders by Amount:")

for order in builtin_result[:5]:
    print(order)

print("\nSelection Sort Complexity: O(n^2)")
print("Merge Sort Complexity: O(n log n)")
print("Built-in Sort Complexity: O(n log n)")



print("\n========== TASK 3 ==========")

def detect_duplicates(orders):
    seen = {}
    duplicates = []

    for order in orders:

        date = datetime.fromisoformat(
            order["createdAt"].replace("Z", "+00:00")
        )

        minute = date.strftime("%Y-%m-%d %H:%M")

        key = (
            order["customerId"],
            order["amount"],
            minute
        )

        if key in seen:
            duplicates.append(order)

        else:
            seen[key] = order

    return duplicates


duplicates = detect_duplicates(orders)

print("Total Duplicate Orders:", len(duplicates))

for order in duplicates[:10]:
    print(order)

print("Time Complexity: O(n) average")
print("Space Complexity: O(n)")




print("\n========== TASK 4 ==========")

# Custom Stack
class Stack:

    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if not self.items:
            return None
        return self.items.pop()

    def display(self):
        print("Stack:", self.items)


# Custom Queue
class Queue:

    def __init__(self):
        self.items = []

    def enqueue(self, item):
        self.items.append(item)

    def dequeue(self):
        if not self.items:
            return None
        return self.items.pop(0)

    def display(self):
        print("Queue:", self.items)


stack = Stack()

stack.push("Order 101 edited")
stack.push("Order 102 edited")
stack.push("Order 103 edited")

stack.display()

print("Undo Operation:", stack.pop())

stack.display()


queue = Queue()

queue.enqueue("Order 101")
queue.enqueue("Order 102")
queue.enqueue("Order 103")

queue.display()

print("Dispatched:", queue.dequeue())

queue.display()



builtin_stack = []

builtin_stack.append("Edit 1")
builtin_stack.append("Edit 2")

print("\nBuilt-in Stack:", builtin_stack)
print("Undo:", builtin_stack.pop())



builtin_queue = deque()

builtin_queue.append("Order 201")
builtin_queue.append("Order 202")

print("Built-in Queue:", builtin_queue)
print("Dispatched:", builtin_queue.popleft())


print("\nCustom Stack Push/Pop: O(1)")
print("Custom Queue Enqueue: O(1)")
print("Custom Queue Dequeue using list: O(n)")
print("Built-in deque Enqueue/Dequeue: O(1)")



print("\n========== TASK 5 ==========")

# Greedy Algorithm
def greedy_change(amount, denominations):

    result = []

    for coin in sorted(denominations, reverse=True):

        count = amount // coin

        if count > 0:
            result.append((coin, count))
            amount %= coin

    if amount != 0:
        return None

    return result


# Dynamic Programming
def minimum_coins(amount, denominations):

    dp = [float("inf")] * (amount + 1)

    dp[0] = 0

    for i in range(1, amount + 1):

        for coin in denominations:

            if coin <= i:
                dp[i] = min(
                    dp[i],
                    dp[i - coin] + 1
                )

    if dp[amount] == float("inf"):
        return None

    return dp[amount]


refund_amount = 786

denominations = [500, 200, 100, 50, 20, 10, 5, 2, 1]

greedy_result = greedy_change(
    refund_amount,
    denominations
)

print("Refund Amount:", refund_amount)
print("Greedy Result:", greedy_result)

print("Greedy Total Coins:",
      sum(count for coin, count in greedy_result))

# Demonstrate a denomination set where greedy fails
print("\nGreedy Failure Demonstration")

failure_denominations = [4, 3, 1]
failure_amount = 6

greedy_failure = greedy_change(
    failure_amount,
    failure_denominations
)

dp_result = minimum_coins(
    failure_amount,
    failure_denominations
)

print("Amount:", failure_amount)
print("Denominations:", failure_denominations)

print("Greedy Result:", greedy_failure)
print("Greedy Coin Count:",
      sum(count for coin, count in greedy_failure))

print("Dynamic Programming Minimum Coins:", dp_result)

print("\nGreedy Complexity: O(n log n)")
print("Dynamic Programming Time Complexity: O(amount * n)")
print("Dynamic Programming Space Complexity: O(amount)")




print("\n================================")
print("ALL 5 TASKS COMPLETED SUCCESSFULLY")
print("================================")
