#!/usr/local/bin/python
# -*- coding: utf-8 -*-

import os
import re
import itertools
import shutil

threshold = '15'
reports_dir = 'Scripts/simian_reports/'
simian_jar_dir = 'Scripts/simian.jar'



os.chdir('..')
file_list = []
for root, dirs, files in os.walk('./Classes'):
   for file in files:
         file_list.append(os.path.join(root, file))

file_list[:] = [x for x in file_list if (str(x).endswith('.m') or str(x).endswith('.mm'))]

single_reports_path = reports_dir + 'single/'
if os.path.exists(single_reports_path):
    shutil.rmtree(single_reports_path)
os.makedirs(single_reports_path)

for file1 in file_list:
    file1 = file1[2:]
    file_path = os.path.abspath(file1)
    xml_file_path = 'Scripts/simian_reports/single/' + file1 + '.xml'
    mkdir_str = os.path.dirname(xml_file_path)
    if not os.path.exists(mkdir_str):
        os.makedirs(mkdir_str)

    xml_file_path = 'Scripts/simian_reports/single/' + file1 + '.xml'
    touch_str = 'touch ' + xml_file_path
    # print touch_str
    os.system(touch_str)

    cmd_str = 'java -jar ' + simian_jar_dir + ' -includes=' + file1 + ' -threshold=' + threshold + ' -formatter=xml > ' + reports_dir + 'single/' + file1 + '.xml'
    # print cmd_str
    os.system(cmd_str)


os.chdir(reports_dir + 'single/')

xml_files = []
for root, dirs, files in os.walk('.'):
   for file in files:
         xml_files.append(os.path.join(root, file))

xml_files[:] = [x for x in xml_files if str(x).endswith('.xml')]

xml_body = '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet href="simian.xsl" type="text/xsl"?><simian version="2.3.33"><check failOnDuplication="true" ignoreCharacterCase="true" ignoreCurlyBraces="true" ignoreIdentifierCase="true" ignoreModifiers="true" ignoreStringCase="true" threshold="' + threshold + '">'

duplicateFileCount = 0
duplicateLineCount = 0
duplicateBlockCount = 0
totalFileCount = 0
totalRawLineCount = 0
totalSignificantLineCount = 0
processingTime = 0


for file2 in xml_files:
    line_count = int(str(os.popen('cat ' + file2 + ' | wc -l').read()).strip())
    if line_count <= int(threshold):
        continue

    crt_file = open(file2, 'r+')
    try:
        content = crt_file.readlines()
        xml_body += "".join(itertools.chain(*content[7:-3]))
        summary_line = content[-3]
        number = re.findall(r'[\d|.]+', summary_line)
        duplicateFileCount += int(number[0])
        duplicateLineCount += int(number[1])
        duplicateBlockCount += int(number[2])
        totalFileCount += int(number[3])
        totalRawLineCount += int(number[4])
        totalSignificantLineCount += int(number[5])
        processingTime += int(number[6])
    finally:
        crt_file.close()

sum_line = '<summary duplicateFileCount="%s" duplicateLineCount="%s" duplicateBlockCount="%s" totalFileCount="%s" \
totalRawLineCount="%s" totalSignificantLineCount="%s" processingTime="%s"/>' % (duplicateFileCount, duplicateLineCount,\
     duplicateBlockCount, totalFileCount, totalRawLineCount, totalSignificantLineCount, processingTime)
xml_body += sum_line
xml_body += '''
    </check>
</simian>
'''


fo = open('../simian.new2.xml', 'w+')
try:
    fo.write(xml_body)
finally:
    fo.close()
