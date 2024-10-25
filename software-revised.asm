/* ASSUMPTIONS:
*   x10-x13 hold function parameters
*       --> in this function, x10 = rs, the start register of array & x11 = n, the amount of values in the array
*   x10 holds function return value
*
*   The program counter is incremented between when instructions are fetched and executed
*       --> this means at the time of executing SVPC x22, 0 the PC points to the instruction one past this (LD x23, x10)
*\

/*
*   ST rt, rs --> store rt into Memory[rs]
*
*   LD rd, rs --> load Memory[rs] into rd
*\


SVPC x1, 0
SUB x0, x0, x0      // ensure x0 contains the integer "0"
INC x11, x11, -1    // n = n - 1 because there are only n-1 memory locations in a n length array
INC x5, x0, 1       // x5 = 0 + 1 = 1. We use x5 as our iteration variable i.
LD x6, x10          // x6 = arr[0] --> the rolling maximum
INC x7, x10, 0      // x7 = &arr[0] --> the current element
INC x12, x1, 32     // Set x12 to the address of the instruction (32 / 4 = 8) places past SVPC x1, 0 --> Loop
INC x13, x1, 64     // Set x13 to the address of the instruction (64 / 4 = 16) places past SVPC x1, 0 --> LoopEnd
INC x14, x1, 76     // Set x14 to the address of the instruction (76 / 4 = 19) places past SVPC x1, 0 --> FinishLoop

// Loop
SUB x15, x5, x11    // x15 = i - n
BRZ x13             // if x15 is 0 --> i == n --> go to LoopEnd. We have checked every element.
LD x16, x7          // x16 = arr[i]
NEG x17, x6         // x17 = -max
ADD x17, x16, x17   // x17 = arr[i] - max
BRZ x14             // if arr[i] - max <= 0 --> max >= arr[i], go to FinishLoop. We do not need to update max.
BRN x14             //
INC x6, x16, 0      // max = arr[i]

// FinishLoop
INC x5, x5, 1       // i++
INC x7, x7, 4       // arr += sizeof(int)
J x12               // next iteration of the for loop

// LoopEnd
INC x10, x6, 0     // return max