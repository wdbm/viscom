#!/bin/bash

################################################################################
#                                                                              #
# viscom-t                                                                     #
#                                                                              #
################################################################################
#                                                                              #
# LICENCE INFORMATION                                                          #
#                                                                              #
# This program converts data to a binary representation and can provide both   #
# a printout of the binary representation and convert it to a series of        #
# terminal flashes for data transmission via visible light.                    #
#                                                                              #
# copyright (C) 2015 William Breaden Madden                                    #
#                                                                              #
# This software is released under the terms of the GNU General Public License  #
# version 3 (GPLv3).                                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU General Public License as published by the Free   #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for     #
# more details.                                                                #
#                                                                              #
# For a copy of the GNU General Public License, see                            #
# <http://www.gnu.org/licenses/>.                                              #
#                                                                              #
################################################################################

name="viscom-t"
version="2015-08-14T1800Z"

echo "encode file as binary representation"
data="$((echo obase=2; hexdump -ve'/1 "%u\n"' "${1}") | bc | xargs printf %08i)"
echo "length of binary representation of data: "${#data}""
characterTransmissionTime=0.03
transmissionTime="$(echo ""${characterTransmissionTime}"*"${#data}"" | bc)"
echo "data binary representation transmission time: "${transmissionTime}" s"

echo "print binary representation of data? (y/n)"
read inputText
inputText="$(echo "${inputText}" | sed 's/\(.*\)/\L\1/')"
if [[ ${inputText} == "y" ]]; then
    echo "${data}"
fi

echo "transmit binary representation of data as terminal flashes? (y/n)"
read inputText
inputText="$(echo "${inputText}" | sed 's/\(.*\)/\L\1/')"
if [[ ${inputText} == "y" ]]; then
    clear
    startTime="$(date +%s)"
    for ((i=0; i<${#data}; i++)); do
        currentCharacter=${data:${i}:1}
        if [ ${currentCharacter} == 0 ]; then
            printf "\e[?5l"
        else
            printf "\e[?5h"
        fi
        sleep "${characterTransmissionTime}"
    done
    printf "\e[?5l"
    clear
    endTime="$(date +%s)"
    timeTaken="$(echo "${endTime}-${startTime}" | bc)"
    echo "time taken: "${timeTaken}" s"
fi
