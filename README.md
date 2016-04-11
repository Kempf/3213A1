# ENGN3213 Assignment 1

###Report

[Overleaf](https://www.overleaf.com/4752390rdbzzc)

###TODO

* Watch mini-lecture on serial comms
* Thorough testing of Function 2
* Function 3
* Combine all in one

### Simulation HOWTO

1. `iverilog $file $tb`
2. `vvp a.out`
3. `gtkwave $dump`

### Status

* **[working]** `cereal.v` - serial state machine, takes data[7:0] and sends it (TB is in `/src/tb/tb_cereal.v`)
* **[working]** `clockdiv.v` - variable rate heartbeat (TB is in `/src/tb/tb_clockdiv.v`)
* **[working]** `debouncer.v` - pushbutton single pulse (TB in `/src/tb/tb_debouncer.v`)
* **[working]** `keyboard.v` - main file, instantiates all others and reads input (TB in `/src/tb/tb_keyboard.v`)
* **[working]** `rom1.v` -- `rom4.v` - store words
* **[fucked up]** `wordgen.v` - word generator for function 2, depricated
* **[tested]** `sendword.v` - word sender
* **[tested]** `switch.v` - controller for word sender, no auto mode yet
* **[partially tested]** `control.v` - word generalor for function 2 - Steves version

###Labs

* TUE 05APR 0900-1300
* MON 11APR 0900-1300
* TUE 19APR 1500-1700
* TUE 26APR 1500-1700
* THU 28APR 1100-1300
* FRI 29APR 0900-1300
* 

