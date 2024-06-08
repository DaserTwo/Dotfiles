#!/bin/bash

bat=`acpi | grep "Battery 1:"`
dat=`date +'%Y-%m-%d %X'`

bat=${bat:11}
bat=${bat/ remaining/) }
bat=${bat/ until charged/) }
bat=${bat/Discharging, /}
bat=${bat/Charging, /\(CH) }
bat=${bat/, / \(}

echo $bat $dat
