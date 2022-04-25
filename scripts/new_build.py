#!/usr/local/bin/python3
'''ADD BUILD'''
import os
import re

current_branch = str()

with open('./current_branch', "rt") as fin:
    total = fin.readlines()
    for line in total:
        current_branch = line.strip()

with open('./pubspec.yaml', "rt") as fin:
    with open('./temp_pubspec.yaml', "wt") as fout:
        total = fin.readlines()
        for line in total:
            regex = re.compile(r'(version:\s)(\d+.\d+.\d+)\+(\d+)')
            match = regex.search(line)
            if match is not None:
                if match.group(2) != current_branch:
                    os._exit(1)
                new_build = int(match.group(3)) + 1
                fout.write(match.group(1)+match.group(2) +
                           '+'+str(new_build)+'\n')
            else:
                fout.write(line)
