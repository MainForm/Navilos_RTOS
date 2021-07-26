This project is for making RTOS called Navilos that introduced at "Embedded OS development project" book.

Before compiling this project, Dependency package must be installed.

Dependency pages list
1.	gcc-arm-none-eabi
2.	qemu-system-arm			//emulator to run arm mcu

We use machine called "realview-pd-a8". You can check this machine in qemu machines list.
Command of listing machine is "qemu-system-arm -M ?"

change of content of book

3.3 excute at QEMU
"gdb-arm-one-eabi" package has been removed in apt.
Replace to "gdb-multiarch" package instead of "gdb-arm-none-eabi" package.
