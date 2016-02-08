# Getting and Cleaning Data - Course Project

## Introduction
This repo contains the course project "Getting and Cleaning Data" course on Coursera.  The R script, `run_analysis.R`, does the following: 

This is the course project for the Getting and Cleaning Data Coursera course.

The R script, `run_analysis.R`, does the following:

1. Download the .zip file with project data if it doesn't already exist
2. Unzip the file if the data directory is not present
3. Build list of labels for features that we want to keep and rename them for clarity
4. Loads the activity and subject data for each dataset, and merges those columns with the dataset. 
5. Combines the two data tables.
6. Creates a tidy dataset that consists of the mean value of each variable for each subject and activity pair.

The end result is shown in the file `tidydata.txt`.

## Code Book
The `CodeBook.md` file list the current variable names as they have been changed for the purposes of this project.

## Original Data

A full description of the data is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The original data can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


