#!/usr/bin/env bash -e
#
# Downloads a site's text to 1 text file, so you can easily
# have it grammer/spellchecked
#
# Requires: wget, html2text
# Recommened: pandoc vs html2text
# Improve at: http://kvz.io/blog/2013/04/19/obtain-all-text-from-your-website/
#

[ -z "${DOMAIN}" ]    && echo "Cannot continue without DOMAIN. " && exit 1
[ -z "${EXCLUDE}" ]   && EXCLUDE="*.css,*.js,*.rss,*.xml,*.png,*.jpg,*.jpeg,*.gif,*.flv,*.swf,*.mp4,*.mov,*.mp3,*.wav"
[ -z "${MAX_DEPTH}" ] && MAX_DEPTH="10"
[ -z "${OUTPUT}" ]    && OUTPUT="./${DOMAIN}.txt"
[ -z "${TMPDIR}" ]    && TMPDIR="../tmp"
[ -z "${TXTENGINE}" ] && [ -x "$(which pandoc)" ]    && TXTENGINE="pandoc -t plain"
[ -z "${TXTENGINE}" ] && [ -x "$(which html2text)" ] && TXTENGINE="html2text -nobs"
[ -z "${TXTENGINE}" ] && echo "Cannot continue without pandoc or html2text. " && exit 1

# wget \
#   --adjust-extension \
#   --convert-links \
#   --directory-prefix="${TMPDIR}" \
#   --level="${MAX_DEPTH}" \
#   --no-parent \
#   --recursive \
#   --reject="${EXCLUDE}" \
#   --restrict-file-names=windows,lowercase \
# "http://${DOMAIN}"

[ -f "${OUTPUT}" ] && rm -f "${OUTPUT}"
find "${TMPDIR}/${DOMAIN}" -type f -print0 -name '*.html' \
  |while read -d $'\0' file; do
  echo "imported by ${0} from: $(echo "${file}" |sed "s@^${TMPDIR}/${DOMAIN}@@")" >> "${OUTPUT}"
  echo "==================================" >> "${OUTPUT}"
  ${TXTENGINE} "${file}" >> "${OUTPUT}"
  echo -e "\n\n\n\n" >> "${OUTPUT}"
done

echo ""
echo " Combined text file ready in ${OUTPUT}"
echo " To cleanup after this script, type: rm -rf \"${TMPDIR}/${DOMAIN}\""
echo ""