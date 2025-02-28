#!/bin/sh

shell_name=$(ps -p $$ -o command | tail -1 | awk '{print $1}')
slashes=$(($(echo $shell_name | tr -cd / | wc -c | awk '{print $1}') + 1))
shell_name=$(echo $shell_name | cut -d/ -f $slashes)

# set colors
RESET="\033[0m"
if [ "$shell_name" = "sh" ] || [ "$shell_name" = "zsh" ]; then
	RED="\033[38;5;124m"
	CYAN="\033[38;5;81m"
	GREEN="\033[38;5;40m"
	PURPLE="\033[38;5;105m"
else
	RED="\033[1;31m"
	CYAN="\033[1;36m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
fi

FILE="out/file.out"

rm -rf out >/dev/null 2>&1
mkdir out >/dev/null 2>&1

if [ -f "../cub3d" ]; then
	printf "$PURPLE cub3d already exists$RESET\n"
else
	printf "$PURPLE compiling cub3d...$RESET"
	make -C .. > /dev/null 2>&1
	make clean -C .. > /dev/null 2>&1
	if ! [ -f "../cub3d" ]; then
		printf "\r\033[K$RED cannot find '../cub3d'$RESET\n"
		printf "$RED check if the executable has the correct name$RESET\n"
		exit 42
	fi
	printf "\033[1K\r$PURPLE cub3d compiled$RESET\n"
fi

test_wrong_map()
{
	printf "\033[1K\r$PURPLE Testing wrong maps, n[$CYAN$1$PURPLE] ok[$GREEN$((i - ko))$PURPLE] ko[$RED$ko$PURPLE]$RESET"
	i=$((i + 1))
	cat $2 > $FILE 2>/dev/null
	printf "\n##################################################\n" >> $FILE
	../cub3d $2 >>$FILE 2>&1 &
	sleep .5
	if ! [ "$(pgrep cub3d)" = "" ]; then
		kill -kill $(pgrep cub3d)
		mv $FILE "out/$1.out"
		ko=$((ko + 1))
	elif [ $(grep "rror" $FILE | wc -l) -eq 0 ]; then
		mv $FILE "out/$1.out"
		ko=$((ko + 1))
	elif [ $(grep "fault" $FILE | wc -l) -gt 0 ] || [ $(grep "egmentation" $FILE | wc -l) -gt 0 ] || [ $(grep "dumped" $FILE | wc -l) -gt 0 ]; then
		mv $FILE "out/$1.out"
		ko=$((ko + 1))
	fi
	rm -f $FILE >/dev/null 2>&1
	return 0
}

ko=0
i=1
while [ $i -lt 49 ]; do
	test_wrong_map $i "maps/wrong$i.cub"
done
# OTHER TESTS
test_wrong_map $i "maps/mapcub"
test_wrong_map $i "maps/mapub"
test_wrong_map $i "maps/mapb"
test_wrong_map $i "maps/map."
test_wrong_map $i "plokmijnuhbygvtfcrdxeszwaq"

i=$((i - 1))

printf "\033[1K\r$PURPLE $i tests executed\n"

if [ $ko -eq 0 ]; then
	rm -rf out >/dev/null 2>&1
else
	rm -rf $FILE >/dev/null 2>&1
fi

printf "$CYAN ok: $GREEN$((i - ko))$CYAN ko: $RED$ko$RESET\n"
