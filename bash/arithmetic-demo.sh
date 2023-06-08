#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label
read -p "Enter your first number" input1
read -p "Enter your second number" input2
read -p "Enter your third number" input3
firstnum=$input1
secondnum=$input2
thirdnum=$input3
sum=$((firstnum + secondnum + thirdnum))
product=$((firstnum * secondnum * thirdnum))
fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")

cat <<EOF
$firstnum plus $secondnum plus $thirdnum is $sum
$firstnum multiplied by $secondnum multiplied by $thirdnum is $product
  - More precisely, it is $fpdividend
EOF
