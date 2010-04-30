#!/bin/bash


# find out in which dir this was launched
BASEDIR=$(dirname $0);
cd ${BASEDIR};
BASEDIR=$(pwd);
cd - >> /dev/null;


TGT="${BASEDIR}/target/js/ebnf.js";
SRC="${BASEDIR}/src/main/syntax/ebnf.par";
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


#work - fill templates
BuildStamp="WARNING: This is a generated file. Do not change directly, but let it be generated again.\nBuild by ${USER} on host ${HOSTNAME} on date $(date)";
EbnfParser=$(cat ${TGT});

echo -n "Processing templates: "
for f in ${TEMPLDIR}/*.js; do
        b="$(basename $f)";
	echo -n "${b}, ";
	echo -n "" > ${TGTDIR}/${b};
	cat $f | while read -r t; do 
		t=${t//@@@BuildStamp@@@/${BuildStamp}};
		t=${t//@@@EbnfParser@@@/${EbnfParser}};
		echo "${t}" >> ${TGTDIR}/${b};
	done; 
done;
echo "Templates processed."
