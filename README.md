# ECE550-PC4 README

## Team Information

| Name        | NetID |
| ----------- | ----- |
| Zhe Fan     | zf70  |
| Zihan Sheng | zs144 |
| Junyi Zhao  | jz423 |


## Clock
clock = what we feed to the skeleton
| Module  | Clock length |
| ------------- | ------------- |
| imem  | clock  |
| dmem  | clock/2  |
| processor  | clock/4  |
| regfile  | clock/4  |


## Functionality

### Opcode

| Instruction  | Opcode |
| ------------- | ------------- |
| R-type  | 00000  |
| Addi  | 00101  |
| Sw  | 00111  |
| Lw  | 01000  |
### Control Circuits
| Control Signal  | Decode |
| ------------- | ------------- |
| Rwe  | Rtype + Addi + Lw  |
| Rdst  | Rtype  |
| ALUinB  | Addi + Lw + Sw  |
| ALUop  | Beq(Not in this checkpoint)  |
| BR  | Beq(Not in this checkpoint)  |
| DMwe  | Sw  |
| JP  | J(Not in this checkpoint)  |
| Rwd  | Lw  |



## Testing

### Basic Testing

- State: ALL PASSED! 🎉

- [x] Test basic functionality of all arithmetic/logic/shifting/loading/saving instructions.

### Half Test Cases Testing

- State: ALL PASSED! 🎉

- [x] Using more cases to test for all arithmetic/logic/shifting/loading/saving instructions.

### Corner Cases Testing

- State: ALL PASSED! 🎉

- [x] Test behaviors when try to assign nonzero value to `$r0`
- [x] Verify handling when overflow happens



## Issue Tracker

### ISSUE 1

- State: ✅ SOLVED!
- Position: `skeleton_tb.v`
- Description: The processor doesn't work, but all four clocks work as expected.
- Fix: RESET the processor when start it.



### ISSUE 2

- State: ✅ SOLVED!
- Position: `clock.v` and `processor.v`
- Description: Only base clock and the one for `imem` work, while the other three clocks stays at `x`.
- Fix: Build a separate clock divider module to quarter the clock frequency.



### ISSUE 3

- State: ✅ SOLVED!
- Position: `processor.v`
- Description: The signal value given to `rstatus` is wrong when overflow happens.
- Fix:
    - Correct the assignment of signal values for the three different scenarios in `rstatus`;
    - Modify the logics of `if_ovf` signal by replacing the choice of gate from `AND` to `OR`.



## Cautions

- Always run `git pull` before you start developing in local repo. This will sync local repo and remote repo.
