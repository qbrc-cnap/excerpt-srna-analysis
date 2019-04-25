Report for exceRpt Small-RNA analysis
---

This document discusses the steps that were performed in the analysis pipeline.  It also describes the format of the output files and some brief interpretation.  For more detailed questions about interpretation of results, consult the documentation of the various tools.

For this exceRpt process, the best source of information is from the developer of the process at <http://github.gersteinlab.org/exceRpt/>

Additional files (namely, intermediate alignment files that are quite large and require specialized software to handle) are available upon request.  They will be deleted within the standard retention period.  Contact the QBRC to discuss options. 

## Outputs:


The main results are contained in a zip-archive and should be downloaded an "unzipped" on your local computer.  The subfolders contain summary files from the merging operation performed by exceRpt.  Please see <http://github.gersteinlab.org/exceRpt/> for the most up-to-date documentation and explanations.  


## Methods:

Please see the publication here: <https://www.cell.com/cell-systems/pdfExtended/S2405-4712(19)30074-2>

Additional information may be found at the Gerstein Lab page: <http://github.gersteinlab.org/exceRpt/>

## Inputs:

Samples and sequencing fastq-format files:

{% for obj in file_display %}
  - {{obj.sample_name}}
    - R1 fastq: {{obj.fastq}}
{% endfor %}

The chosen reference genome: {{genome}}


## Version control:
To facilitate reproducible analyses, the analysis pipeline used to process the data is kept under git-based version control.  The repository for this workflow is at 

<{{git_repo}}>

and the commit version was {{git_commit}}.

This allows us to run the *exact* same pipeline at any later time, discarding any updates or changes in the process that may have been added. 