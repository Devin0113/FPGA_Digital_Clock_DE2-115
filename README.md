# FPGA Digital Clock with Alarm System

## 1. 项目简介 (Project Introduction)

此fpga项目是一个基于DE2-115的带闹铃系统数字时钟，使用quartus软件编写。项目使用语言为vhdl语言。此项目实现了在DE2-115开发板上运行的以时分秒为单位的24小时制数字时钟，功能不仅仅包括基本的数字时钟功能，还包括调时功能和闹铃功能。闹铃功能使用LED来模拟而并非输出了音频。

This FPGA project is a digital clock with an alarm system based on the DE2-115 development board. It is written using the Quartus software and implemented in VHDL. The project aims to run a 24-hour digital clock on the DE2-115 development board, featuring basic clock functions, time adjustment, and alarm capabilities. The alarm function is simulated using LEDs rather than audio output.

此项目是本学生在学校的fpga课程中的结课设计，可能存在一些不足。

This project serves as the final assignment in the author's FPGA course at school and may have some limitations.

## 2. 硬件平台 (Hardware Platform)

项目基于DE2-115 FPGA板进行开发。

The project is developed on the DE2-115 FPGA board.

## 3. 主要功能 (Main Features)

将工程下载至开发板DE2-115后，运行即显示时间，且时间按秒流逝。

按下按键“KEY3”，功能会在“显示时间”、“调整时间”、“设置闹钟”中循环切换。

在“调整时间”功能时，按下按键“KEY2”从右往左循环选择位置，按下按键“KEY1”正向调整此位置的数值。

在“设置闹钟”功能时，按下按键“KEY2”从右往左循环选择位置，按下按键“KEY1”正向调整此位置的数值。

在非“显示时间”功能时，选中位置的数码管会被“高亮”。

在任何时候，当闹铃时间与电子钟时间一致时，会触发闹钟，在此工程中即LED会有不一样的显示（若需要有其他响应需要修改代码及管脚分配）。

After downloading the project to the DE2-115 development board, it will display the time, and the time will elapse in seconds. Pressing the "KEY3" button will cycle through the functions of "Display Time," "Adjust Time," and "Set Alarm." In the "Adjust Time" function, pressing the "KEY2" button cycles through positions from right to left, and pressing the "KEY1" button adjusts the value at the selected position. In the "Set Alarm" function, pressing the "KEY2" button cycles through positions from right to left, and pressing the "KEY1" button adjusts the value at the selected position. In non-"Display Time" functions, the selected position's display will be "highlighted." At any time, when the alarm time matches the electronic clock time, the alarm will be triggered, in this project, the LED will display differently (if other responses are needed, code and pin assignments need to be modified).

## 4. 使用说明 (Usage Instructions)

可以自行新建工程，将“seg.vhd”、“clkdiv.vhd”、“mainfunc.vhd”、“alarm.vhd”、“digital_clock.vhd”加载进工程，将“digital_clock.vhd”设为顶层。需要自行分配管脚。

You can create a new project and add "seg.vhd," "clkdiv.vhd," "mainfunc.vhd," "alarm.vhd," and "digital_clock.vhd" to the project. Set "digital_clock.vhd" as the top-level module. Pin assignments need to be done manually.

## 5. 许可证信息 (License Information)

使用MIT许可证。

This project is licensed under the MIT License.
