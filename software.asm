/* ASSUMPTIONS:
*   x10-x13 hold function parameters
*       --> in this function, x10 = rs, the start register of array & x11 = rt, the end + 1 register of the array
*   x10 holds function return value
*
*   The program counter is incremented between when instructions are fetched and executed
*       --> this means at the time of executing SVPC x22, 0 the PC points to the instruction one past this (LD x23, x10)
*\

/*
*   ST rt, rs --> store rt into Memory[rs]
*
*   LD rd, rs --> load Memory[rs] into rd
\*

// use address at x21 to store rolling maximum
// start of loop of find maximum, here's the idea:
// check if current element of maximum is > rolling maximum
// if so, update rolling max
// increment current element of maximum
// if current element of array is a address greater than the address of the end of the list, skip the next line
// return to top of loop and increment address of current element
SVPC x26, 44    // point to the instruction after the loop
SVPC x25, 28    // point to the instruction if we skip updating the rolling max
SVPC x22, 0     // Save a reference to one instruction past this (LD x23, x10)
LD x23, x10     // load Memory[current address of array] into x23... this is the the value of "current element"
ST x23, x21     // store the first value (assumed max at start) into memory[x21]
LD x29, x21     // x21 stores the address of rolling max, so we use LD to get the value and store it in register x29 (this is *arr)
SUB x24, x23, x29   // subtract current value - rolling maximum. -x = a - max --> x = max - a we just use this form since we want to skip work if negative
BRN x25
ST x23, x21    // if the subtraction is positive
// the next instruction is where the SVPC x25, 128 line will jump to
// if the subtraction is positive, we dont have a new maximum, so we jump here
INC x10, 4 // since x10 is a memory address to the first element of the array, we increment by the next address which requires an increment of 4 bytes
SUB x27, x10, x11 // same logic as above, here it's current address of array - end address of array
BRN x26 // if every value has been checked, we skip the next branch (which restarts the loop) and contine to the end of the function
J x22   // if we haven't gotten through every value, jump to the start of the loop
// x26 points to the next instruction which only occurs when the loop is over and we know the max value
LD x29, x21     // we get the value of our rolling max again in case it changed in the final iteration
ST x29, x10     // store the value of rolling max into x10, the return parameter. We are done.