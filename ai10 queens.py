class BnB:
    def printSolution(self, board, N):
        for i in range(N):
            for j in range(N):
                print(board[i][j], end=" ")
            print()

    def isSafe(self, row, col, slashCode, backslashCode, rowLookup, slashCodeLookup, backslashCodeLookup):
        if (slashCodeLookup[slashCode[row][col]] or
                backslashCodeLookup[backslashCode[row][col]] or
                rowLookup[row]):
            return False
        return True

    def solveNQueensUtil(self, N, board, col, slashCode, backslashCode, rowLookup, slashCodeLookup,
                         backslashCodeLookup):
        if col >= N:
            return True

        for i in range(N):
            if self.isSafe(i, col, slashCode, backslashCode, rowLookup, slashCodeLookup, backslashCodeLookup):
                board[i][col] = 1
                rowLookup[i] = True
                slashCodeLookup[slashCode[i][col]] = True
                backslashCodeLookup[backslashCode[i][col]] = True

                if self.solveNQueensUtil(N, board, col + 1, slashCode, backslashCode, rowLookup, slashCodeLookup,
                                         backslashCodeLookup):
                    return True

                board[i][col] = 0
                rowLookup[i] = False
                slashCodeLookup[slashCode[i][col]] = False
                backslashCodeLookup[backslashCode[i][col]] = False

        return False

    def solveNQueens(self, N):
        if N == 2 or N == 3:
            print("Solution does not exist for N =", N)
            return False

        board = [[0 for _ in range(N)] for _ in range(N)]
        slashCode = [[0 for _ in range(N)] for _ in range(N)]
        backslashCode = [[0 for _ in range(N)] for _ in range(N)]
        rowLookup = [False] * N
        x = 2 * N - 1
        slashCodeLookup = [False] * x
        backslashCodeLookup = [False] * x

        for rr in range(N):
            for cc in range(N):
                slashCode[rr][cc] = rr + cc
                backslashCode[rr][cc] = rr - cc + (N - 1)

        if not self.solveNQueensUtil(N, board, 0, slashCode, backslashCode, rowLookup, slashCodeLookup,
                                     backslashCodeLookup):
            print("Solution does not exist")
            return False

        self.printSolution(board, N)
        return True


class BT:
    def printSolution(self, N, board):
        for i in range(N):
            for j in range(N):
                print(board[i][j], end=" ")
            print()

    def isSafe(self, N, board, row, col):
        for i in range(col):
            if board[row][i] == 1:
                return False

        for i, j in zip(range(row, -1, -1), range(col, -1, -1)):
            if board[i][j] == 1:
                return False

        for i, j in zip(range(row, N, 1), range(col, -1, -1)):
            if board[i][j] == 1:
                return False

        return True

    def solveNQUtil(self, N, board, col):
        if col >= N:
            return True

        for i in range(N):
            if self.isSafe(N, board, i, col):
                board[i][col] = 1
                if self.solveNQUtil(N, board, col + 1) == True:
                    return True
                board[i][col] = 0

        return False

    def solveNQ(self, N):
        if N == 2 or N == 3:
            print("Solution does not exist for N =", N)
            return False

        board = [[0 for _ in range(N)] for _ in range(N)]

        if not self.solveNQUtil(N, board, 0):
            print("Solution does not exist")
            return False

        self.printSolution(N, board)
        return True


def main():
    board = BnB()
    board2 = BT()

    while True:
        print("N-Queens Problems\n1. Branch and Bound\n2. Backtracking\n3. Exit\nEnter your choice:")
        ch = int(input())

        if ch == 1:
            N = int(input("Enter number of columns and rows: "))
            board.solveNQueens(N)
        elif ch == 2:
            N = int(input("Enter number of columns and rows: "))
            board2.solveNQ(N)
        elif ch == 3:
            break
        else:
            print("Invalid Input!")


if __name__ == "__main__":
    main()
