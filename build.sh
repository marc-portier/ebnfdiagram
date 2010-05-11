#!/bin/bash


# find out in which dir this was launched
BASEDIR=$(dirname $0);
cd ${BASEDIR};
BASEDIR=$(pwd);
cd - >> /dev/null;


TGT="${BASEDIR}/target/js/ebnf-jq.js";
SRC="${BASEDIR}/src/main/syntax/ebnf-jq.par";
TEMPLDIR="${BASEDIR}/src/templates";

#set/find/test/warn js interpreter
JSI=${JSI:-"rhino"};
if [[ ! -x $(which $JSI) ]]; then
	echo "Can't find javascript interpreter: ${JSI}. Please set it through env var JSI";
	exit 1;
fi

#set/find/test/warn jscc script
JSCC=${JSCC:-"${BASEDIR}/tools/jscc/jscc.js"};
if [[ ! -f ${JSCC} ]]; then
	echo "Can't find js-cc script: ${JSCC}. Please set it through env var JSCC";
	exit 1;
fi
JSCCDIR=$(dirname ${JSCC});


#work - create target dir
TGTDIR=$(dirname $TGT);
mkdir -p ${TGTDIR};


#work - generate parser
echo -n "Creating Parser: ";
cd ${JSCCDIR};
${JSI} ${JSCC} -o ${TGT} ${SRC}
cd - >> /dev/null
echo "Parser Generated.";

