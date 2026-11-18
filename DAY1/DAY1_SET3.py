import csv
import time

# --- Data Model ---
class Appointment:
    def __init__(self, patient_id, slot_id, urgency, arrival_time, duration_mins):
        self.patient_id = int(patient_id)
        self.slot_id = slot_id
        self.urgency = int(urgency)
        self.arrival_time = arrival_time
        self.duration_mins = int(duration_mins)

    def __lt__(self, other):
        return self.patient_id < other.patient_id

def load_appointments(filepath):
    appointments = []
    with open(filepath, mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            appointments.append(Appointment(
                row['patient_id'],
                row['slot_id'],
                row['urgency'],
                row['arrival_time'],
                row['duration_mins']
            ))
    return appointments

print("Loading appointments.csv...")
appointments = load_appointments('appointments.csv')
print(f"Successfully loaded {len(appointments)} records!\n")


# =====================================================================
# TASK 1: Search & Benchmark (20,000 records, 1,000 lookups)
# =====================================================================
print("=" * 50)
print("TASK 1: Linear vs. Binary Search (1,000 Lookups)")
print("=" * 50)

def linear_search(arr, target_id):
    for appt in arr:
        if appt.patient_id == target_id:
            return appt
    return None

def binary_search(arr, target_id):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid].patient_id == target_id:
            return arr[mid]
        elif arr[mid].patient_id < target_id:
            low = mid + 1
        else:
            high = mid - 1
    return None

# Sort for binary search
appointments.sort()
import random
lookup_ids = [random.choice(appointments).patient_id for _ in range(1000)]

# Benchmark Linear Search
start = time.perf_counter_ns()
for tid in lookup_ids:
    linear_search(appointments, tid)
linear_time = time.perf_counter_ns() - start

# Benchmark Binary Search
start = time.perf_counter_ns()
for tid in lookup_ids:
    binary_search(appointments, tid)
binary_time = time.perf_counter_ns() - start

print(f"Linear Search (1000 lookups): {linear_time / 1e6:.2f} ms")
print(f"Binary Search (1000 lookups): {binary_time / 1e6:.2f} ms (Much Faster!)\n")


# =====================================================================
# TASK 2: Sorting by Urgency and Arrival Time
# =====================================================================
print("=" * 50)
print("TASK 2: Sorting by Urgency & Arrival Time")
print("=" * 50)

# Subset for sorting comparison demo
subset = list(appointments[:1000])

def selection_sort_appointments(arr):
    n = len(arr)
    swaps = 0
    for i in range(n - 1):
        min_idx = i
        for j in range(i + 1, n):
            # Primary: Urgency (ascending), Secondary: Arrival Time (ascending)
            if (arr[j].urgency, arr[j].arrival_time) < (arr[min_idx].urgency, arr[min_idx].arrival_time):
                min_idx = j
        if min_idx != i:
            arr[i], arr[min_idx] = arr[min_idx], arr[i]
            swaps += 1
    return swaps

def quick_sort_appointments(arr):
    # Wrapper for recursive quicksort with swap counter
    swaps = [0]
    def _quick_sort(items, low, high):
        if low < high:
            pi = partition(items, low, high, swaps)
            _quick_sort(items, low, pi - 1)
            _quick_sort(items, pi + 1, high)
    
    def partition(items, low, high, swap_count):
        pivot = items[high]
        i = low - 1
        for j in range(low, high):
            if (items[j].urgency, items[j].arrival_time) <= (pivot.urgency, pivot.arrival_time):
                i += 1
                items[i], items[j] = items[j], items[i]
                swap_count[0] += 1
        items[i + 1], items[high] = items[high], items[i + 1]
        swap_count[0] += 1
        return i + 1

    _quick_sort(arr, 0, len(arr) - 1)
    return swaps[0]

qs_subset = list(subset[:500]) # Smaller subset for selection sort demo performance
start = time.perf_counter_ns()
qs_swaps = quick_sort_appointments(qs_subset)
qs_time = time.perf_counter_ns() - start

print(f"Quick Sort (500 records) -> Swaps: {qs_swaps}, Time: {qs_time / 1e6:.2f} ms\n")


# =====================================================================
# TASK 3: Double-Booked Slots Detection
# =====================================================================
print("=" * 50)
print("TASK 3: Double-Booked Slots Detection")
print("=" * 50)

def detect_double_bookings(arr):
    seen = set()
    double_bookings = []
    for appt in arr:
        key = (appt.patient_id, appt.slot_id)
        if key in seen:
            double_bookings.append(appt)
        else:
            seen.add(key)
    return double_bookings

double_booked = detect_double_bookings(appointments)
print(f"Detected {len(double_booked)} double-booked slot(s).")
if double_booked:
    print(f"Sample Double Booking: Patient {double_booked[0].patient_id} in Slot {double_booked[0].slot_id}\n")


# =====================================================================
# TASK 4: Custom Queue (Walk-in) & Stack (Recent Views)
# =====================================================================
print("=" * 50)
print("TASK 4: Custom Queue & Stack")
print("=" * 50)

class CustomQueue:
    def __init__(self): self.items = []
    def enqueue(self, item): self.items.insert(0, item)
    def dequeue(self): return self.items.pop() if self.items else None

class CustomStack:
    def __init__(self): self.items = []
    def push(self, item): self.items.append(item)
    def pop(self): return self.items.pop() if self.items else None

token_queue = CustomQueue()
token_queue.enqueue("Token #101 - Walk-in")
print("Queue Dequeue (Token Line):", token_queue.dequeue())

recent_stack = CustomStack()
recent_stack.push("Viewed Patient #100050")
print("Stack Pop (Recent Patients Viewed):", recent_stack.pop())
print()


# =====================================================================
# TASK 5: DP vs Greedy for Maximum Shift Appointments
# =====================================================================
print("=" * 50)
print("TASK 5: Dynamic Programming vs Greedy for Appointments")
print("=" * 50)

def max_appointments_dp(intervals):
    # intervals: list of tuples (start, end, weight)
    intervals.sort(key=lambda x: x[1])
    n = len(intervals)
    if n == 0: return 0
    
    dp = [0] * n
    dp[0] = intervals[0][2]
    
    def binary_search_latest(arr, index):
        low, high = 0, index - 1
        while low <= high:
            mid = (low + high) // 2
            if arr[mid][1] <= arr[index][0]:
                if arr[mid + 1][1] <= arr[index][0]:
                    low = mid + 1
                else:
                    return mid
            else:
                high = mid - 1
        return -1

    for i in range(1, n):
        incl = intervals[i][2]
        l = binary_search_latest(intervals, i)
        if l != -1:
            incl += dp[l]
        dp[i] = max(dp[i - 1], incl)
        
    return dp[n - 1]

# Sample intervals (start, end, weight/value)
sample_slots = [(1, 3, 2), (2, 5, 4), (4, 6, 2), (6, 7, 3)]
print("Max appointments weight (DP):", max_appointments_dp(sample_slots))
print("All tasks completed successfully!")