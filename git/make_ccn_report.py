#! /usr/local/bin/python

import re
import os

os.system('lizard ../Classes/ -s cyclomatic_complexity > /var/tmp/ccn_log.txt')

f_in_strings = '/var/tmp/ccn_log.txt'
fp = open(f_in_strings, 'r+')
try:
    content = fp.readlines()
    lineArray = {}
    for eachline in content[3:]:
        if eachline.startswith('--------------------------------------------------------------'):
            break
        key = re.findall(r' [a-zA-Z_;].*$', eachline)[0]
        value = re.findall(r'[\d|.]+', eachline)[1]
        if len(value) == 1:
            value = '00' + value
        elif len(value) == 2:
            value = '0' + value
        lineArray[key] = value
    array = []
    for key in lineArray:
        str1 = str(lineArray[key]) + str(key) + '\n'
        array.append(str1)
    array.sort(reverse=True)
finally:
    fp.close()

f_out_string = '/var/tmp/ccn_log_sort.txt'
fp = open(f_out_string, 'w')
try:
    fp.writelines(array)
finally:
    fp.close()

os.system('open /var/tmp/ccn_log_sort.txt')
