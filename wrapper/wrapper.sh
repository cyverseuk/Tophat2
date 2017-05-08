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

ARGSU=" ${bowtie_index} ${pair1} ${pair2} ${quality_file} ${GTF} ${read-mismatches} ${read-gap-length} ${read-edit-dist} ${read-realign-edit-dist} ${min-anchor} ${splice-mismatches} ${min-intron-length} ${max-intron-length} ${max-multihits} ${suppress-hits} ${transcriptome-max-hits} ${prefilter-multihits} ${max-insertion-length} ${max-deletion-length} ${quality_type} ${integer-quals} ${color} ${library-type} ${transcriptome-only} ${mate-inner-dist} ${mate-std-dev} ${no-novel-juncs} ${no-novel-indels} ${no-gtf-juncs} ${no-coverage-search} ${coverage-search} ${microexon-search} ${report-secondary-alignments} ${no-discordant} ${no-mixed} ${segment-mismatches} ${segment-length} ${min-coverage-intron} ${max-coverage-intron} ${min-segment-intron} ${max-segment-intron} ${keep-fasta-order} ${bowtie2-preset} ${bowtie2-N} ${bowtie2-L} ${bowtie2-i} ${bowtie2-n-ceil} ${bowtie2-gbar} ${bowtie2-mp} ${bowtie2-np} ${bowtie2-rdg} ${bowtie2-rfg} ${bowtie2-score-min} ${bowtie2-D} ${bowtie2-R} ${fusion-search} ${fusion-anchor-length} ${fusion-min-dist} ${fusion-read-mismatches} ${fusion-multireads} ${fusion-multipairs} ${fusion-ignore-chromosomes} ${rg-id} ${rg-sample} ${rg-library} ${rg-description} ${rg-platform-unit} ${rg-center} ${rg-date} ${rg-platform}"
BOWTIEINDEXU=`echo ${bowtie_index} | sed -e 's/ /, /g'`
PAIR1CMD=`echo ${pair1} | sed -e 's/ /,/g'`
PAIR1U=`echo ${pair1} | sed -e 's/ /, /g'`
PAIR2CMD=`echo ${pair2} | sed -e 's/ /,/g'`
PAIR2U=`echo ${pair2} | sed -e 's/ /, /g'`
GTFU="${GTF}"
QUALITY_FILE1CMD=`echo ${quality_file1} | sed -e 's/ /,/g'`
QUALITY_FILE1U=`echo ${quality_file1} | sed -e 's/ /, /g'`
QUALITY_FILE2CMD=`echo ${quality_file2} | sed -e 's/ /,/g'`
QUALITY_FILE2U=`echo ${quality_file2} | sed -e 's/ /, /g'`
INPUTSU="${BOWTIEINDEXU}, ${PAIR1U}, ${PAIR2U}, ${GTFU}, ${QUALITY_FILE1U}, ${QUALITY_FILE2U}"
echo "bowtie index is " "${BOWTIEINDEXU}"
echo "pair 1 file(s) are ""${PAIR1U}"
echo "pair 2 file(s), if provided, are ""${PAIR2U}"
echo "GTF file, is provided, is ""${GTFU}"
echo "Quality file(s) for read(s) 1, if provided, are ""${QUALITY_FILE1U}"
echo "Quality file(s) for read(s) 2, if provided, are ""${QUALITY_FILE2U}"
echo "input files are ""${INPUTSU}"
echo "arguments are ""${ARGSU}"

CMDLINEARGS=""
#check if Bowtie index is given as an archive ar as a list of files
#in the first case, unzip it. Otherwise check all files are here.
#not checking if all files are in archive as i don't want to run the job in the condor-master
if file --mime-type "./${BOWTIEINDEXU}" | grep -q gzip$
  then
    echo Bowtie index provided as archive
    CMDLINEARGS+="unzip ${bowtie_index}; "
    #get base name of index for command
    BASEINDEX=$(basename "${bowtie_index}")
    BASEINDEX="${BASEINDEX%%.*}"
  else
    if [ "${BOWTIEINDEXU#*\.1\.bt2}" != "${BOWTIEINDEXU}" ] && [ "${BOWTIEINDEXU#*\.2\.bt2}" != "${BOWTIEINDEXU}" ] && [ "${BOWTIEINDEXU#*\.3\.bt2}" != "${BOWTIEINDEXU}" ] && [ "${BOWTIEINDEXU#*\.4\.bt2}" != "${BOWTIEINDEXU}" ] && [ "${BOWTIEINDEXU#*\.rev\.1\.bt2}" != "${BOWTIEINDEXU}" ] && [ "${BOWTIEINDEXU#*\.rev\.2\.bt2}" != "${BOWTIEINDEXU}" ]
      then
        echo #all files are provided. do nothing
        temp=(${bowtie_index})
        BASEINDEX=$(basename "${temp}")
        BASEINDEX="${BASEINDEX%%.*}"
      else
        if [ "${BOWTIEINDEXU#*\.1\.bt2}" == "${BOWTIEINDEXU}" ]
          then
            >&2 echo 1.bt2 is missing
        fi
        if [ "${BOWTIEINDEXU#*\.2\.bt2}" == "${BOWTIEINDEXU}" ]
          then
            >&2 echo 2.bt2 is missing
        fi
        if [ "${BOWTIEINDEXU#*\.3\.bt2}" == "${BOWTIEINDEXU}" ]
          then
            >&2 echo 3.bt2 is missing
        fi
        if [ "${BOWTIEINDEXU#*\.4\.bt2}" == "${BOWTIEINDEXU}" ]
          then
            >&2 echo 4.bt2 is missing
        fi
        if [ "${BOWTIEINDEXU#*\.rev\.1\.bt2}" == "${BOWTIEINDEXU}" ]
          then
            >&2 echo rev.1.bt2 is missing
        fi
        if [ "${BOWTIEINDEXU#*\.rev\.2\.bt2}" == "${BOWTIEINDEXU}" ]
          then
            >&2 echo rev.2.bt2 is missing
        fi
        >&2 echo "You are missing some index file(s), please check your input."
        debug
        exit 1;
    fi
fi

CMDLINEARGS+="tophat2 ${read-mismatches} ${read-gap-length} ${read-edit-dist} ${read-realign-edit-dist} ${min-anchor} ${splice-mismatches} ${min-intron-length} ${max-intron-length} ${max-multihits} ${suppress-hits} ${max-insertion-length} ${max-deletion-length} ${quality_type} ${integer-quals} ${color} ${library-type} ${mate-inner-dist} ${mate-std-dev} ${no-novel-juncs} ${no-novel-indels} ${no-gtf-juncs} ${no-coverage-search} ${coverage-search} ${microexon-search} ${report-secondary-alignments} ${no-discordant} ${no-mixed} ${segment-mismatches} ${segment-length} ${min-coverage-intron} ${max-coverage-intron} ${min-segment-intron} ${max-segment-intron} ${keep-fasta-order} ${bowtie2-n-ceil} ${bowtie2-gbar} ${bowtie2-mp} ${bowtie2-np} ${bowtie2-rdg} ${bowtie2-rfg} ${bowtie2-score-min} ${fusion-search} ${fusion-anchor-length} ${fusion-min-dist} ${fusion-read-mismatches} ${fusion-multireads} ${fusion-multipairs} ${fusion-ignore-chromosomes} ${rg-id} ${rg-sample} ${rg-library} ${rg-description} ${rg-platform-unit} ${rg-center} ${rg-date} ${rg-platform} "

if [ -n "${quality_file1}" ]
  then
    CMDLINEARGS+="--quals "
    #if this doesn't make sense it will fail in the next ifs
fi

#the commented parts are useful if we changed this to deal with mixed cases

#if [ -n "${pair1}" -a -n "${pair2}" ] #this is now useless as they are required by agave, but keep it as a flag for mixed case
#  then
    if [ -n "${quality_file1}" -a -z "${quality_file2}" ] || [ -z "${quality_file1}" -a -n "${quality_file2}" ]
      then
        >&2 echo "You provided paired reads, but quality files only for one of the pairs. Please provide the other one as well."
        debug
        exit 1;
    fi
#fi
#if [ -z "${pair2}" -a -n "${quality_file2}" ]
#  then
#  >&2  echo "You provided quality files for pair 2, but no pair 2."
#  debug
#  exit 1;
#fi

if [ -n "${bowtie2-preset}" ]
  then
    echo "WARNING: you used a preset, every other bowtie2 D R N L i option specified will be ignored: "
    echo "${bowtie2-N} ${bowtie2-L} ${bowtie2-i} ${bowtie2-R} ${bowtie2-D} will be ignored."
    CMDLINEARGS+="${bowtie2-preset} "
  else
    CMDLINEARGS+="${bowtie2-N} ${bowtie2-L} ${bowtie2-i} ${bowtie2-R} ${bowtie2-D} "
fi

if [ -n "${GTF}" ]
  then
    CMDLINEARGS+="${transcriptome-only} ${transcriptome-max-hits} ${prefilter-multihits} --GTF ${GTFU} "
  else
    if [ -n "${transcriptome-only}" -o -n "${transcriptome-max-hits}" -o -n "${prefilter-multihits}" ]
      then
        echo "WARNING: --transcriptome-only, --transcriptome-max-hits and --prefilter-multihits can only be used when providing a GTF file. The one you set ( ${transcriptome-only} ${transcriptome-max-hits} ${prefilter-multihits}) will be ignored."
    fi
fi

CMDLINEARGS+="--num-threads 16 --output-dir output ${BASEINDEX} ${PAIR1CMD} ${PAIR2CMD} ${QUALITY_FILE1CMD} ${QUALITY_FILE2CMD} "

echo ${CMDLINEARGS}
chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/tophat2:v2.1.0 >> lib/condorSubmitEdit.htc
echo executable               = ./launch.sh >> lib/condorSubmitEdit.htc
echo transfer_input_files               = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
echo transfer_output_files              = output >> lib/condorSubmitEdit.htc
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
