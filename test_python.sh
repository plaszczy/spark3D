#!/bin/bash
# Copyright 2018 Julien Peloton
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Script to launch the python test suite and measure the coverage.
## Must be launched as ./test_python.sh <SCALA_BINARY_VERSION>

# First build the assembly JAR
sbt 'set test in assembly := {}' ++$1 assembly

# Then run the test suite
cd pyspark3d
for i in *.py
do
    coverage run -a --source=. $i
done

## Print and store the report if local
## Otherwise the result is sent to codecov (see .travis.yml)
isLocal=`whoami`
if [ $isLocal == "julien" ]
then
  coverage report

  echo " " >> cov.txt
  echo $(date) >> cov.txt
  coverage report >> cov.txt

  coverage html
  cd ../
fi