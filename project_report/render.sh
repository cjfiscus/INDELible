#!/bin/bash

## requires R pkgs pandoc, markdown installed
## requires LaTeX installation

echo "rmarkdown::render('project_report.Rmd', clean=TRUE)" | R --slave
