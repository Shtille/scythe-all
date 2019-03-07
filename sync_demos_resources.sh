#!/bin/bash
# Script for resource syncronization between 'scythe/data' and 'demos/data'.
# 'demos/data' fully includes 'scythe/data' and extends it.
# Should be called from this directory.
cd scythe/data
rsync -r -R * ../../demos/data
