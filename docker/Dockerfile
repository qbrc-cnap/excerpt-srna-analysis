
FROM rkitchen/excerpt:latest

# Install python dev and pandoc:
RUN yum install -y python36-devel.x86_64 python36-setuptools pandoc.x86_64 git

# Install pip3:
RUN easy_install-3.6 pip

RUN mkdir /opt/software

# Install libStatGen and fastQValidator:
RUN cd /opt/software && \
  git clone https://github.com/statgen/libStatGen.git && \
  cd libStatGen && \
  make && \
  cd .. && \
  git clone https://github.com/statgen/fastQValidator.git && \
  cd fastQValidator && \
  make && \
  make install

# Install some Python3 libraries:
ADD requirements.txt /opt/software/
RUN pip3 install -r /opt/software/requirements.txt

RUN mkdir /opt/scripts
ADD merge_runs.R /opt/scripts/
ADD mergePipelineRuns_functions.R /opt/scripts/ 

# The script for generating the markdown report:
ADD generate_report.py /usr/local/bin/
RUN chmod +x /usr/local/bin/generate_report.py

# Add the report template and styling:
RUN mkdir /opt/report
ADD report.md /opt/report/
ADD report.css /opt/report/

ENTRYPOINT ["/bin/bash"]
