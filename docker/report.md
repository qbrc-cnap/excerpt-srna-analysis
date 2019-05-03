Report for exceRpt Small-RNA analysis
---

This document discusses the steps that were performed in the analysis pipeline.  It also describes the format of the output files and some brief interpretation.  For more detailed questions about interpretation of results, consult the documentation of the various tools.

For this exceRpt process, the best source of information is from the developer of the process at <http://github.gersteinlab.org/exceRpt/>

Additional files (namely, intermediate alignment files that are quite large and require specialized software to handle) are available upon request.  They will be deleted within the standard retention period.  Contact the qBRC to discuss options.

## Outputs:

The main results are contained in a zip-archive and should be downloaded an "unzipped" on your local computer.  The subfolders contain summary files from the merging operation performed by exceRpt.  Please see <http://github.gersteinlab.org/exceRpt/> for the most up-to-date documentation and explanations.  

Read mapping and filtering results are summarized in the following:

Table 1. Read Counts for each RNA species 
{}

Figure 1a. Read count distribution by different filtering and mapping criteria

{Figures/qc_postfilter_count.png}

Figure 1b. Read count percentage distribution by different filtering and mapping criteria

{Figures/qc_postfilter_perc.png}

Figure 2. sRNA class read distribution per samples
{Figures/sRNA_all_mapping_count.png}

Figure 3. Sense sRNA read counts per samples
{Figures/sRNA_senseonly_count.png}



## Methods:
The Extracellular RNA Processing Tools (exceRpt) was used for this analysis.  The exceRpt analysis pipeline is composed of a cascade of serial computational filters and alignments as our analytical core.   First, it automatically detects and removes 3’ adapter sequences and then RNA-Seq reads of consistently low-quality reads are removed.  Then the process mapped reads against NCBI’s UniVec/Vecscreen database to filter out common laboratory contaminants as well as all primary endogenous ribosomal RNAs(5S, 5.8S, 18S, 28S, and 45S).   The remaining reads are aligned to the host genome and transcriptome.  Transcript abundance are calculated using both raw read counts and normalized reads per million (RPM).  Mapped transcripts are then annotated with priority order of miRBase, tRNAscan, piRNA, GENCODE.

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