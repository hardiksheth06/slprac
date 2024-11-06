def selection_sort(arr):
    n = len(arr)
    for i in range(n):
        min_idx = i
        for j in range(i + 1, n):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]

def main():
    while True:
        print("\nMenu:")
        print("1. Enter elements and sort")
        print("2. Exit")
        choice = int(input("Enter your choice: "))
        
        if choice == 1:
            arr = list(map(int, input("Enter numbers separated by space: ").split()))
            selection_sort(arr)
            print("Sorted array:", arr)
        elif choice == 2:
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
