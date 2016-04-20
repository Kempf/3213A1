# ENGN3213 Assignment 1

###Report

[Overleaf](https://www.overleaf.com/4752390rdbzzc)

###TODO

* Watch mini-lecture on serial comms
* Implementation of Function 2 - Incorporate the 'one word per second requirement'
* Function 3
* Combine all in one

### Simulation HOWTO

1. `iverilog $file $tb`
2. `vvp a.out`
3. `gtkwave $dump`

### Status

* **[working]** `cereal.v` - serial state machine, takes data[7:0] and sends it
* **[working]** `clockdiv.v` - variable rate heartbeat
* **[working]** `debouncer.v` - pushbutton single pulse
* **[working]** `/f1_ausf_a/keyboard.v` - main file, instantiates all others and reads input
* **[WIP]** `/f2_ausf_d/rom.v` - store words
* **[WIP]** `/f2_ausf_d/keyboard.v` - word sender for function 2

###Labs

* TUE 26APR 1500-1700
* THU 28APR 1100-1300
* FRI 29APR 0900-1300
