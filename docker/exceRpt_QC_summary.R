library(ggplot2)
library(ggthemes)
library(plyr)
library(scales)
library(reshape)
#library(cccbDGEpipeline)

args = commandArgs(trailingOnly=TRUE)

PROJECT_DIR=args[1]
# this is the test directory
PROJECT_DIR='/Users/yaoyuwang/Desktop/report/'
# end of test directory
RESULT_DIR=paste0(PROJECT_DIR, "/exceRpt_output/")

# output directory
OUTDIR=paste0(PROJECT_DIR, "Figures")
ifelse(!dir.exists(OUTDIR), dir.create(OUTDIR), FALSE)

# read in mapping statistics
mapping.stats=read.table(paste0(RESULT_DIR, "exceRpt_readMappingSummary.txt"))
# limit the sample name to 20 characters
rownames(mapping.stats)=substr(rownames(mapping.stats),0,20)



# Preprocessing filtering QC
qc_parameters=c(
  "failed_quality_filter",   
  "failed_homopolymer_filter",
  "calibrator",               
  "UniVec_contaminants",      
  "rRNA",
  "genome",
  "not_mapped_to_genome_or_libs"
)





mapping.stats_qc=mapping.stats[,qc_parameters]
sample_names=rownames(mapping.stats_qc)
mapping.stats_qc=cbind(Sample=sample_names, mapping.stats_qc)
mapping.stats_qc_melt=melt(mapping.stats_qc, var.id="Sample")

qc_postfilter_count=ggplot(mapping.stats_qc_melt, aes(x=Sample, y=value, fill=variable))+
  geom_bar(stat = "identity")+
  theme(axis.text.x=element_text(angle=75,hjust=1,vjust=1, size=6),
        legend.text=element_text(size=5))

qc_postfilter_perc=ggplot(mapping.stats_qc_melt, aes(x=Sample, y=value, fill=variable))+
         geom_bar(stat = "identity", position="fill")+
        theme(axis.text.x=element_text(angle=75,hjust=1,vjust=1,size=6),
              legend.text=element_text(size=5))

ggsave(paste(OUTDIR,"qc_postfilter_count.png", sep="/"), 
       plot=qc_postfilter_count,
       width = 6, height = 4)
ggsave(paste(OUTDIR,"qc_postfilter_perc.png", sep="/"), 
       plot=qc_postfilter_perc,
       width = 6, height = 4)

###################################
# Mapped Read Distributions

mapping.stats_genome=mapping.stats[,grep("genome", colnames(mapping.stats))][,1:2]
mapping.stats_genome=cbind(Sample=sample_names, mapping.stats_genome)
mapping.stats_genome_melt=melt(mapping.stats_genome, var.id="Sample")

qc_genome_mapping_count=ggplot(mapping.stats_genome_melt, aes(x=Sample, y=value, fill=variable))+
  geom_bar(stat = "identity")+
  theme(axis.text.x=element_text(angle=75,hjust=1,vjust=1))

ggsave(paste(OUTDIR,"qc_genome_mapping_count.png", sep="/"), 
       plot=qc_genome_mapping_count,
       width = 6, height = 4)


###################################
# Mapped sRNA Read Distributions
sRNA_parameters=c(
  "miRNA_sense",                 
  "miRNA_antisense",             
  "miRNAprecursor_sense",        
  "miRNAprecursor_antisense",   
  "tRNA_sense",                  
  "tRNA_antisense",              
  "piRNA_sense",                
  "piRNA_antisense",             
  "gencode_sense",               
  "gencode_antisense"
)
mapping.stats_sRNA=mapping.stats[,sRNA_parameters]
mapping.stats_sRNA=cbind(Sample=sample_names, mapping.stats_sRNA)
mapping.stats_sRNA_melt=melt(mapping.stats_sRNA, var.id="Sample")

qc_sRNA_mapping_count=ggplot(mapping.stats_sRNA_melt, aes(x=Sample, y=value, fill=variable))+
  geom_bar(stat = "identity")+ scale_fill_brewer(palette="Set1")+
  theme(axis.text.x=element_text(angle=75,hjust=1,vjust=1))

ggsave(paste(OUTDIR,"sRNA_all_mapping_count.png", sep="/"), 
       plot=qc_sRNA_mapping_count,
       width = 6, height = 4)



###################################
# Mapped sRNA sense Read Distributions
sRNA_parameters=c(
  "miRNA_sense",                 
  "tRNA_sense",                  
  "piRNA_sense"                
)
mapping.stats_sRNA=mapping.stats[,sRNA_parameters]
mapping.stats_sRNA=cbind(Sample=sample_names, mapping.stats_sRNA)
mapping.stats_sRNA_melt=melt(mapping.stats_sRNA, var.id="Sample")


qc_sRNA_mapping_count=ggplot(mapping.stats_sRNA_melt, aes(x=Sample, y=value, fill=variable))+
  geom_bar(stat = "identity")+ scale_fill_brewer(palette="Set1")+
  theme(axis.text.x=element_text(angle=75,hjust=1,vjust=1))

ggsave(paste(OUTDIR,"sRNA_sense_mapping_count.png", sep="/"), 
       plot=qc_sRNA_mapping_count,
       width = 6, height = 4)



