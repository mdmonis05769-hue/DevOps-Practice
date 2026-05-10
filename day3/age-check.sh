#!/bin/bash

echo "Enter your age:"
read age

if [ $age -ge 18 ]
then
    echo "Eligible"
else
    echo "Not Eligible"
fi
