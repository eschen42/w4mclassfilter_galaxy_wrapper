#!/bin/bash

# run test and write new output files, showing progress to command line output
planemo conda_install .
planemo serve --host 0.0.0.0 --conda_dependency_resolution .

