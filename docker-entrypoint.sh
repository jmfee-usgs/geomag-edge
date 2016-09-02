#! /bin/bash


# bash normally ignores SIGTERM
_term () {
  echo '## Caught SIGTERM, stopping edge processes'
  kill -TERM "$alarm" "$edgemom" "$querymom"
}
trap _term SIGTERM


################################################################################
# configure environment

source ~vdl/.bashrc

echo '## Running docker-configure'
./docker-configure.sh


################################################################################
# start edge processes

echo '## Starting alarm'
java -jar bin/EdgeCWB.jar alarm '^' 128 -alarm -noaction -nocfg -nodb &
alarm=$!

echo '## Starting edgemom'
java -jar bin/EdgeCWB.jar edgemom '1#1' 499 -max -f edgemom.setup &
edgemom=$!

echo '## Starting querymom'
java -jar bin/EdgeCWB.jar querymom '1#1' 161 -f querymom.setup &
querymom=$!


################################################################################
# wait for edge processes to exit

wait "$alarm" "$edgemom" "$querymom"
