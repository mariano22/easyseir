echo -e "Extracting PCR tests \n"
awk -F',' '$8 ~ "P" {print $1" 00 00 00,"$3","$5","$7","$11","$12";"}' Covid19Determinaciones.csv >output.csv
echo -e "Removing non printable characters\n"
tr -cd '[:print:]' < output.csv >datosPCR.csv
echo -e "Removing - symbols\n"
sed -i 's/-/ /g' datosPCR.csv
echo -e "Adding return symbols\n"
sed -i 's/;/\n/g' datosPCR.csv
echo -e "Removing quotations\n"
sed -i 's/"/ /g' datosPCR.csv
echo -e "Convert date to epoch\n"
gawk -F ',' '{print mktime($1)","$2","$3","$4","$5","$6}' datosPCR.csv >output.csv  
echo -e "Remove temporary file\n"
mv output.csv datosPCR.csv

