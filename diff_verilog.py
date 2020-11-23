#!/usr/bin/env python3
import re
import os
import subprocess

def parse_file(file_path):
    module_dict = {}
    current_module_name = ""
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if line.startswith("module"):
                r = re.search('module(.*)\(', line)
                module_name = r.group(1)
                if "\\$paramod" in module_name:
                    current_module_name = module_name.replace("\\$paramod", "")
                else:
                    current_module_name = module_name
                begin = current_module_name.find("\\")
                if begin != -1:
                    end = current_module_name.find("\\", begin + 1, len(current_module_name))
                    current_module_name = current_module_name[begin:end]
                if current_module_name == "":
                    current_module_name = module_name
                current_module_name = current_module_name.replace(' ', '')
                current_module_name = current_module_name.replace('\\', '')


            if current_module_name != "":
                if current_module_name in module_dict:
                    module_dict[current_module_name].append(line)
                else:
                    module_dict[current_module_name] = [line]

            line = f.readline()

    return module_dict

surelog = parse_file('build/top.v')
sv = parse_file('build-sv/top.v')

os.makedirs("compare", exist_ok=True)

for key in sorted(surelog.keys()):
    with open(f'compare/surelog_{key}.v', 'w') as f:
        f.writelines(surelog[key])

for key in sorted(sv.keys()):
    with open(f'compare/sv_{key}.v', 'w') as f:
        f.writelines(sv[key])

for key in surelog.keys():
    if key in sv.keys():
        subprocess.run(["diff", "-y", "--color=always", "--suppress-common-lines", f"compare/surelog_{key}.v", f"compare/sv_{key}.v"])
        sv.pop(key)
    else:
        print(f"Additional module in Surelog: {key}")

for key in sv.keys():
    print(f"Additional module in SystemVerilog: {key}")

