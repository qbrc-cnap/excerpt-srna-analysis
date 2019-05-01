#!/usr/bin/python3

import subprocess as sp
import json
import argparse
import sys
import os
from jinja2 import Environment, FileSystemLoader

# some variables for common reference.
# many refer to keys set in the json file of
# config variables
TEMPLATE = 'template'
OUTPUT = 'output'
CFG = 'config_vars'
FQ = 'fastq_files'
GIT_REPO = 'git_repo'
GIT_COMMIT = 'git_commit'
GENOME = 'genome'


class InputDisplay(object):
    '''
    A simple object to carry info to the markdown report.
    '''
    def __init__(self, sample_name, fq):
        self.sample_name = sample_name
        self.fastq = os.path.basename(fq)


def get_jinja_template(template_path):
    '''
    Returns a jinja template to be filled-in
    '''
    template_dir = os.path.dirname(template_path)
    env = Environment(loader=FileSystemLoader(template_dir), lstrip_blocks=True, trim_blocks=True)
    return env.get_template(
        os.path.basename(template_path)
    )


def fill_template(context, template_path, output):
    if os.path.isfile(template_path):
        template = get_jinja_template(template_path)
        with open(output, 'w') as fout:
            fout.write(template.render(context))
    else:
        print('The report template was not valid: %s' % template_path)
        sys.exit(1)


def parse_input():
    '''
    Parses the commandline input, returns a dict
    '''
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', required=True, dest=TEMPLATE)
    parser.add_argument('-o', required=True, dest=OUTPUT)
    parser.add_argument('-j', required=True, dest=CFG)
    parser.add_argument('-f', required=True, dest=FQ, nargs='+')

    args = parser.parse_args()
    return vars(args)


if __name__ == '__main__':

    # parse commandline args and separate the in/output from the
    # context variables
    arg_dict = parse_input()
    output_file = arg_dict.pop(OUTPUT)
    input_template_path = arg_dict.pop(TEMPLATE)

    # parse the json file which has additional variables
    j = json.load(open(arg_dict[CFG]))

    # alter how the files are displayed:
    fastq_files = arg_dict[FQ]
    samples = [os.path.basename(x)[:-len('_R1.fastq.gz')] for x in fastq_files]
    file_display = []
    for fq, s in zip(fastq_files, samples):
        ipd = InputDisplay(s, fq)
        file_display.append(ipd)

    # make the context dictionary
    context = {}
    context.update(arg_dict)
    context.update(j)
    context.update({'file_display': file_display})

    # fill and write the completed report:
    fill_template(context, input_template_path, output_file)
