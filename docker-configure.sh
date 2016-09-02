#! /bin/bash


# only run configuration the first time
RUN_ONCE=ran-docker-configure
if [ -f "${RUN_ONCE}" ]; then
  echo "## Already configured";
  exit;
else
  touch "${RUN_ONCE}"
fi


################################################################################
# configuration/defaults

# files to write
EDGE_CONFIG=edge.config
EDGE_PROP=edge.prop
EDGEMOM_SETUP=edgemom.setup
QUERYMOM_SETUP=querymom.setup

# figure out container ip address
IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`


################################################################################
# write edge.config
echo "## Writing ${EDGE_CONFIG}"
cat > "${EDGE_CONFIG}" <<-DONE
Host=`hostname`
HostIP=$IP
PublicIP=$IP
DONE


################################################################################
# write edge.prop
echo "## Writing ${EDGE_PROP}"
cat > "${EDGE_PROP}" <<-DONE
Station=DOCKER
Network=DOCKER
Node=1
Instance=1

DBServer=NoDB
StatusDBServer=NoDB
MetaDBServer=NoDB
MySQLServer=NoDB
AlarmIP=localhost
StatusServer=localhost

ndatapath=1
daysize=3001
extendsize=2000
ebqsize=20000
nday=10000000
datapath=/data/
logfilepath=/home/vdl/log/

emailTo=
SMTPFrom=
SNWServer=
SNWPort=0
DONE


################################################################################
# write edgemom.setup

echo "## Writing ${EDGEMOM_SETUP}"
cat > "${EDGEMOM_SETUP}" <<-DONE
Mom:EdgeMom:-empty >>edgemom
Echn:EdgeChannelServer:-nodb >>echn
#Load:MiniSeedServer:-nohydra -noudpchan -p 7965 >>load
#Replace:MiniSeedServer:-nohydra -noudpchan -p 7974 >>replace
RawInput:RawInputServer:-nohydra -p 7981 -rsend 100 >>rawinput
DONE


################################################################################
# write querymom.setup

echo "## Writing ${QUERYMOM_SETUP}"
cat > "${QUERYMOM_SETUP}" <<-DONE
Mom:EdgeMom:-empty >>querymom
Echn:EdgeChannelServer:-nodb >>echnqm
QS:gov.usgs.cwbquery.EdgeQueryServer:-allowrestricted -mdsport 0 >>queryserver
CWBWS:gov.usgs.anss.waveserver.CWBWaveServer:-allowrestricted -daysback 10000 -maxthreads 500 -mdsport 0 -nodb -p 2060 -nofilter -queryall >>cwbws
DLQS:gov.usgs.cwbquery.DataLinkToQueryServer:-empty >>dlqs
QSC:gov.usgs.cwbquery.QuerySpanCollection:-d 86400 -bands * >>qsc
DONE


################################################################################
# Have EDGE process config files
#
#echo "## Running NoDBConfig"
#java -cp ~vdl/bin/EdgeCWB.jar gov.usgs.anss.edgemom.NoDBConfig \
#    -config "${EDGE_CONFIG}" \
#    -once \
#    -prop "${EDGE_PROP}"
