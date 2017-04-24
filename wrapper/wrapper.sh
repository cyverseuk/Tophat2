#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

ARGSU=" ${bowtie_index} ${pair1} ${pair2} ${quality_file} ${GTF} ###### ${read-mismatches} ${read-gap-length} ${read-edit-dist} ${read-realign-edit-dist} ${min-anchor} ${splice-mismatches} ${min-intron-length} ${max-intron-length} ${max-multihits} ${suppress-hits} ${transcriptome-max-hits} ${prefilter-multihits} ${max-insertion-length} ${max-deletion-length} ${quality_type} ${integer-quals} ${color} ${library-type} ${transcriptome-only} ${mate-inner-dist} ${mate-std-dev} ${no-novel-juncs} ${no-novel-indels} ${no-gtf-juncs} ${no-coverage-search} ${coverage-search} ${microexon-search} ${report-secondary-alignments} ${no-discordant} ${no-mixed} ${segment-mismatches} ${segment-length} ${min-coverage-intron} ${max-coverage-intron} ${min-segment-intron} ${max-segment-intron} ${keep-fasta-order} ${bowtie2-preset} ${bowtie2-N} ${bowtie2-L} ${bowtie2-i} ${bowtie2-n-ceil} ${bowtie2-gbar} ${bowtie2-mp} ${bowtie2-np} ${bowtie2-rdg} ${bowtie2-rfg} ${bowtie2-score-min} ${bowtie2-D} ${bowtie2-R} ${fusion-search} ${fusion-anchor-length} ${fusion-min-dist} ${fusion-read-mismatches} ${fusion-multireads} ${fusion-multipairs} ${fusion-ignore-chromosomes} ${rg-id} ${rg-sample} ${rg-library} ${rg-description} ${rg-platform-unit} ${rg-center} ${rg-date} ${rg-platform}"
BOWTIEINDEXU="${bowtie_index}"
PAIR1CMD=`echo ${pair1} | sed -e 's/ /,/g'`
PAIR1U=`echo ${pair1} | sed -e 's/ /, /g'`
PAIR2CMD=`echo ${pair2} | sed -e 's/ /,/g'`
PAIR2U=`echo ${pair2} | sed -e 's/ /, /g'`
GTFU="${GTF}"
QUALITY_FILECMD=`echo ${quality_file} | sed -e 's/ /,/g'`
QUALITY_FILEU=`echo ${quality_file} | sed -e 's/ /, /g'` ####
INPUTSU="${BOWTIEINDEXU}, ${PAIR1U}, ${PAIR2U}, ${GTFU}, ${QUALITY_FILEU}"
echo "bowtie index is " "${BOWTIEINDEXU}"
echo "pair 1 file(s) are ""${PAIR1U}"
echo "pair 2 file(s) are ""${PAIR2U}"
echo "GTF file, is provided, is ""${GTFU}"
echo "input files are ""${INPUTSU}"
echo "arguments are ""${ARGSU}"

CMDLINEARGS=""

if [ -n "${bowtie2-preset}" ]
  then
    echo "WARNING: you used a preset, every other bowtie2 D R N L i option specified will be ignored: "
    echo "${bowtie2-N} ${bowtie2-L} ${bowtie2-i} ${bowtie2-R} ${bowtie2-D} will be ignored."
    CMDLINEARGS+="${bowtie2-preset}"
  else
    CMDLINEARGS+="${bowtie2-N} ${bowtie2-L} ${bowtie2-i} ${bowtie2-R} ${bowtie2-D} "
fi

echo ${CMDLINEARGS}
chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/tophat2:v2.1.0 >> lib/condorSubmitEdit.htc
echo executable               = ./launch.sh >> lib/condorSubmitEdit.htc
echo transfer_input_files               = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
echo arguments                          = ${CMDLINEARGS} >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/tophat2/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
