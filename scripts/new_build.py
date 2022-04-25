#!/usr/local/bin/python3
'''ADD BUILD'''
import re

with open('./pubspec.yaml', "rt") as fin:
    with open('./temp_pubspec.yaml', "wt") as fout:
        total = fin.readlines()
        for line in total:
            regex = re.compile(r'\+(\d+)')
            match = regex.search(line)
            if match is not None:
                new_build = int(match.group(1)) + 1
                fout.write(line[:match.span()[0]+1]+str(new_build)+'\n')
            else:
                fout.write(line)
