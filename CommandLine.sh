#!/bin/sh

# The dataset command_line_file already only includes the three variables needed:
# $1 = address
# $2 = numPeopleVisited
# $3 = numPeopleWant

awk -F"\t" '{print $1}' command_line_file.tsv > address

# We search for the countries' names in the address and save the country name
# in another file named country.

while IFS= read -r line; do
if [[ "$line" == *'United States'* ]]; then echo 'United States';
elif [[ "$line" == *'England'* ]]; then echo 'England';
elif [[ "$line" == *'France'* ]]; then echo 'France';
elif [[ "$line" == *'Italy'* ]]; then echo 'Italy';
elif [[ "$line" == *'Spain'* ]]; then echo 'Spain';
else echo 'Other Country'; fi; done < address > country

awk -F"\t" '{print $2}' command_line_file.tsv > data1
awk -F"\t" '{print $3}' command_line_file.tsv > data2


# We take the country names and add them to the other two variables numPeopleVisited and numPeopleWant.

paste country data1 data2 -d"," > final_data


# We remove those lines (rows) containg 'Other Country' as we are not interested
# in countries that are not England, France, US, Italy and Spain

while IFS= read -r line; do if [[ "$line" == *'Other Country'* ]]; then
:; else echo $line; fi; done < final_data > final_data1

# question 1
echo ' '
echo 'Question number 1: How many places can be found in each country?'
echo ' '
echo 'Country | Count'
echo '---------------------'
# cut -d"," -f 1 final_data1 | sort | uniq -c
# or
awk -F"," '{a[$1]+=1}END{for(i in a) print i,a[i]}' final_data1 | sort
echo '---------------------'

# question 2

# NR = number of processed rows

echo ' '
echo 'Question number 2: How many people, on average, have visited the places in each country?'
echo ' '
echo 'Country | Avg.'
echo '---------------------'
awk -F"," '{(a[$1]+=$2) && (c[$1]+=1)}END{for(i in a) print i,(a[i]/c[i])}' final_data1 | sort
echo '---------------------'

# question 3

echo ' '
echo 'Question number 3: How many people in total want to visit the places in each country?'
echo ' '
echo 'Country | Sum'
echo '---------------------'
awk -F"," '{a[$1]+=$3}END{for(i in a) print i,a[i]}' final_data1 | sort
echo '---------------------'

