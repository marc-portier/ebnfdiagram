#!/bin/bash


# find out in which dir this was launched
BASEDIR=$(dirname $0);
cd ${BASEDIR};
BASEDIR=$(pwd);
cd - >> /dev/null;




#set/find/test/warn js interpreter
JSI=${JSI:-"rhino"};
if [[ ! -x $(which $JSI) ]]; then
	echo "Can't find javascript interpreter: ${JSI}. Please set it through env var JSI";
	exit 1;
fi

#set/find/test/warn parser script
PARSER=${PARSER:-"${BASEDIR}/target/js/ebnf-cli.js"};
if [[ ! -f ${PARSER} ]]; then
	echo "Can't find parser script: ${PARSER}. Please set it through env var PARSER, or make sure you've built it with build.sh";
	exit 1;
fi

#set/find/test/warn input
EBNF_FILE=${1:-"${BASEDIR}/test/sample/ebnf.ebnf"};
if [[ ! -f ${EBNF_FILE} ]]; then
	echo "Can't find ebnf file to parse: ${EBNF_FILE}. Please pass it as an argument to this script.";
	exit 1;
fi

#work
${JSI} ${PARSER} ${EBNF_FILE}
