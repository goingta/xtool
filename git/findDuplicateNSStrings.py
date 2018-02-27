#!/usr/bin/python
# -*- encoding: utf-8 -*-

import os

import re

import sys
import commands


reload(sys)
sys.setdefaultencoding('utf-8')
reload(sys)

os.chdir('..')
_, PWD = commands.getstatusoutput('pwd')
print PWD

file_list = []
str_dict = {}
for root, dirs, files in os.walk('Classes'):
    for file1 in files:
        file_list.append(os.path.join(root, file1))

file_list[:] = [x for x in file_list if (str(x).endswith('.m') or str(x).endswith('.mm'))]

for file1 in file_list:
    buf = open(PWD + '/' + file1, "r+")
    while True:
        line = buf.readline()
        if not line:
            break
        if line.find('@"') == -1:
            continue
        regex = '@"[^\n\"]{2,}"'
        finds = re.findall(regex, line)
        for item in finds:
            item = item.encode('utf-8')
            # print item
            if item not in str_dict:
                str_dict[item] = 1
            else:
                cnt = str_dict[item]
                str_dict[item] = (cnt + 1)
    buf.close()

str_list = sorted(str_dict.items(), key=lambda x:x[1], reverse=True)


# print str_new_dict


file2 = "/var/tmp/dulicate_strings.txt"
b2 = open(file2, "w+")
for item in str_list:
    b2.write(item[0] + "  " + str(item[1]))
    b2.write('\n')

b2.close()

os.system('open ' + file2)





