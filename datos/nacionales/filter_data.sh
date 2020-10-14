echo -e "Extracting confirmed cases\n"
awk -F',' '$21 ~ "C" {print $23" 00 00 00,"$10" 00 00 00,"$9" 00 00 00,"$12" 00 00 00,"$14" 00 00 00,"$16" 00 00 00,"$22","$24","$3";"}' Covid19Casos.csv >output.csv
echo -e "Removing non printable characters\n"
tr -cd '[:print:]' < output.csv >datos.csv
echo -e "Removing - symbols\n"
sed -i 's/-/ /g' datos.csv
echo -e "Adding return symbols\n"
sed -i 's/;/\n/g' datos.csv
echo -e "Removing quotations\n"
sed -i 's/"/ /g' datos.csv
echo -e "Convert date to epoch\n"
gawk -F ',' '{print mktime($1)","mktime($2)","mktime($3)","mktime($4)","mktime($5)","mktime($6)","$7","$8","$9}' datos.csv >output.csv  
echo -e "Remove temporary file\n"
mv output.csv datos.csv

