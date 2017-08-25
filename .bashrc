function emacsd() {
	if [ $1 ]
	then
		echo emacs -nw --daemon="$1"
		command emacs -nw --daemon="$1"
	fi
}

function emacsc() {
        if [ $1 ]
        then
                echo emacsclient -t -s "$1"
                command emacsclient -t -s "$1"
        fi
}

alias downloads="find /home/*/Downloads -maxdepth 1"

function odoo_used_fields() {
	find . -type f -name \*.py | while read l; do egrep -o "self\.[A-Za-z_]+" "$l"; done | sort | uniq
}

function tail_grep() {
    if [ $1 ] && [ $2 ]
    then
	tail -f $1 | egrep -i "$2" --line-buffered --color=always | sed -e "s/^.*$/&1\n\n\n/"
    else
	echo ERROR
    fi
}

function ping_sshhosts() {
	cat ~/.ssh/config | grep 192\.168 | cut -d ' ' -f2 | while read l; do ping $l -c 3; done
}

function clone_repos() {
    cat repos2 | while read l
    do
	p=$(cut -d ' ' -f1 <<< $l)
	v=$(cut -d ' ' -f2 <<< $l)
	folder=$(grep -oP "(?<=/)[^/]+(?=.git)" <<< $p)
	if [ ! -d $folder ]
	then
	    c="git clone $p"
	    echo $c && eval $c
	else
	    echo "ERROR: FOLDER "$folder" Alredy exists"
	fi
	if [ -d $folder ]
	then
	    c="cd $folder"
	    echo $c && eval $c
	    c="git checkout $v"
	    echo $c && eval $c
	    c="cd .."
	    echo $c && eval $c
	else
	    echo "ERROR CLONING "$folder
	fi
    done
    if [ -d locale_ar ]
    then
	ls -d locale_ar/*/ | while read l
	do
	    if [ -f $l/__openerp__.py ] || [ -f $l/__manifest__.py ]
	    then
		d=$(basename $l)
		if [ ! -d $d ] && [ ! -L $d ]
		then
		    c="ln -s $l $d"
		    echo $c && eval $c
		else
		    echo "ERROR: directory "$d" alredy exists"
		fi
	    fi
	done
    fi
}

alias status='/usr/sbin/service --status-all 2>&1 | sort -k 1,3 | grep -P "(?<=\[ )." --color=always | less -R'

function anotar_always() {
    case "$1" in
	1)
	    echo "every 300 seconds 5 min"
	    while true; do sleep 300; (anotar_trabajo &); done &
	    ;;
	2)
	    echo "every 600 seconds 10 min"
	    while true; do sleep 600; (anotar_trabajo &); done &
	    ;;
	3)
	    echo "every 900 seconds 15 min"
	    while true; do sleep 900; (anotar_trabajo &); done &
	    ;;
	*)
	    echo "every 1800 seconds 30 min"
	    while true; do sleep 1800; (anotar_trabajo &); done &
	    ;;
    esac
}

function anotar_trabajo() {
    if [ ! "$(ps aux | grep zenity | grep -q ANOTAR)" ]
    then
	zenity --error --text="ANOTAR TRABAJO \!\!\nANOTAR TRABAJO \!\!"
    fi
}

function odoo10_start() {
	if [ $1 ]
	then
		# python2 -c "import odoo; print odoo.cli.main()"
		python2 -c "import sys; sys.argv = sys.argv + ['--config', '"$1"']; import odoo; print odoo.cli.main()"
	else
		python2 -c "import sys; sys.argv = ['', '--database', 'odoo']; import odoo; print odoo.cli.main()"
	fi
}

function docker-rmi-none() {
	docker images | egrep "<none>" | tr -s ' ' | cut -d $' ' -f3 | while read l; do docker rmi $l; done
}

function nodejs-list-required() {
    # $1 is maxdepth
    find . -maxdepth $1 -type f -name \*.js | while read l
    do
	grep "^var.*=.*require(" $l --color
    done | grep -oP "(?<=['\"])[a-z][^']+(?=['\"])" | sort | uniq
}

function docker_rm_all() {
	docker ps -a | egrep -o " [^ ]*?$" | tail -n +2 | while read l; do docker rm $l; done
}

function odoo_fields() {
	ls -d ./*/ | while read l
	do
		egrep -ior ".*= fields\.(Binary|Boolean|Char|Date|Datetime|FailedValue|Field|Float|Html|Integer|Many2many|Many2one|MetaField|Monetary|One2many|Reference|Selection|Serialized|Text)" $l |\
		cut -d ':' -f 2 |\
		while read a
		do
			echo $l $a
		done
	done
}

function find-time-extension() {
	find  $1 -type f -name \*.$2 -printf "%Ts %p\n"
}

function file-sort-time-last() {
	size=20
	depth=5
	if [ $1 ]
	then
		size=$1
		if [ $2 ]
		then
			depth=$2
		fi
	fi
	sort -g -t 1 | tail -$size | while read l; do egrep -o "(/[^/]+){1,"$depth"}$" <<< $l; done
}

function kill-process-user-except() {
    if [ $1 ]
    then
	ps aux | cut -d ' ' -f 1 | sort | uniq | grep -v "$1" | \
	    while read l
	    do
		pkill -u $l
	    done
    else
	echo "You have to provide a user name as first parameter"
    fi
}

function pgdump() {
	if [ $2 ]
	then
		pg_dump -U $1 -w --no-owner --file=$2_$(date +"%d_%m_%Y_%s").sql $2
	else
		echo "you have to pass the database name to backup"
	fi
}

function tomp3() {
	if [ -f $1 ]
	then
		ffmpeg -i "$1" -af "volume=10dB" -b 128K "$1.mp3"
	else
		echo "Not a file "$1
	fi
}

function chunder() {
	ls | while read l
	do
		f=$(sed -e 's/ /_/g' <<< $l)
		if [ ! -f "$f" ]
		then
			mv "$l" "$f"
		# else
		# 	echo file exist $f
		fi
	done
}

function findinext() {
	find . -type f -name \*.$1 | while read l; do grep $2 $l 2> /dev/null && echo $l; done
}

function kernels() {
	cat /boot/grub/grub.cfg  | egrep "linux[^/]+/[^0-9]+([0-9]+\.)+[0-9]+"
}

function git-branchs() {
	find . -type d -name \.git | while read l; do a=$(dirname $l); echo $a; cd $a; git branch; done
}

alias chrome="ignore /usr/bin/google-chrome --no-sandbox"

function pypath() {
	python2 -c "import sys; from pprint import pprint; [pprint(p) for p in sys.path]" | egrep -o "/.[^']+"
}

function diff-current() {
	# git diff current repository in current branch
	if [ ! $2 ]
	then
		# first version
		beginning=0
		if [ ! $1 ]
		then
			echo "\$1 should be the last version to compare"
		fi
	fi
	branch=$(git branch | grep "*" | cut -d ' ' -f2)
	if [ ! $branch ]
	then
		return 1
	fi
	git diff $branch~$1 $branch~$beginning
}

function links() {
	# find all symbolyc links
	find . -type l | while read l; do ls -a $l | grep -oP "(?<=..).*"; done
}

function date-modify() {
	# ls -trd ./*/ | while read l; do echo $(stat $l --format "%y") $l; done
	find .  -maxdepth 1 -printf "%T@ %p\n" 
}

function grep_manifest() {
    # find text inside odoo addon manifiest
    # it has to be inside the addons folder
    if [ ! $(pwd | grep "/addons") ]
    then
	echo "You are not in the addons path"
	return 1
    fi
    find . -type f -maxdepth 2 | \ 
    egrep "(__manifest__.py|__openerp__.py)" | while read l
    do
	egrep "$@" $l
    done
}

function exts() {
	egrep -o "\.[a-z]+$" | sort | uniq -c | sort -g -k 1 -r
}

function exclude() {
	search="$(echo "$(echo '(' $(echo $@  | tr -s ' ' '|') ')')" | sed 's/ //g')"
	egrep -v "$search"
}

# scp -P 8075 ~/.bashrc skyline@$SSH_HOST:~/.bashrc_minetech
# scp ~/.bashrc skyline@$SSH_HOST:~/.bashrc_minetech -P 8069


# /opt/odoo/odoo-pyEnv/lib/python2.7/site-packages/M2Crypto/SMIME.py
# 270
# pkcs7 = m2.pkcs7_sign0(

function new_tty() {
	# within docker 
	# open terminal failed: missing or unsuitable terminal: bash
	exec >/dev/tty 2>/dev/tty </dev/tty
}

function attach-docker() {
	docker exec -t -i $1 /bin/bash
}

function kill-X() {
	psg X | egrep ":[0-9]" | kill-them
}

function ssh-pass() {
	ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no "$@"
}

function lsof-kill() {
	if [ ! $2 ]
	then
		echo "this command requires two arguments '\$1' is the process name '\$2' is the port where is listening"
		return
	fi
	IFS=
	proc=$(lsof -i | grep LISTEN | grep "$1" | grep "$2")
	echo $proc
	if [ $proc ]
	then
		echo $proc | kill-them
	fi
}

function threads() {
	ps -e -T | egrep "^[ ]*"$1"[ ]+"
}

function threadsof() {
	# get threads of process name
	threads $(pidof $1)
}

function ncolumn() {
	tr -s ' ' | cut -d ' ' -f $1
}

function lsof-kill-them() {
	tr -s ' ' | cut -d ' ' -f2 | kill-them
}
function docker-names () {
	docker ps -a --format "{{.Names}}"
}

function docker-kill-names() {
	while read l
	do
		echo killing containner ... $l
		docker kill "$l"
	done
}

function docker-rm() {
	while read l
	do
		docker rm "$l"
	done
}

function docker-rm-all() {
	docker-names | docker-rm
}

function docker-kill-all() {
	docker-names | docker-kill-names
}

function diff_colors() {
	while read l; do if [ $(egrep -oc "^<" <<< "$l") -gt 0 ]; then echo -en "\033[31m"; else echo -en "\033[32m"; fi; echo $l; done
}

function odoo_diff_core_files() {
	cat files | while read l; do fodoo8=$(egrep $l"\$" odoo8_files); fodoo10=$(egrep $l"\$" odoo10_files); echo $fodoo8 $fodoo10; done | cut -d $' ' -f1,2 | less -R
}

gitlab_ip=192.168.69.6
gitlab_api_tocken=1euyyGKWq3jPUPjpszao

function gitlab-create-repo() {
	if [ ! $1 ]
	then
		echo you need to specify a name for the repository, exiting ...
		exit 1
	fi
	curl -H "Content-Type:application/json" http://$gitlab_ip/api/v3/projects?private_token=$gitlab_api_tocken -d "{ \"name\":\""$1"\" }"
	return $?
}

function backup-day() {
	if [ ! $1 ] || [ ! -f $1 ] && [ ! -d $1 ]
	then
		"'"$1"' is not a directory"
		return 1
	fi
	zip -r $1_$(date +"%d_%m_%Y_%s").zip $1
}
function menuitem() {
	# TODO
	# find . -type f -name \*.xml | while read l; do sed -n '/ <menuitem/,/\/>/p' $l | tr -s $'\n' ' ' | tr -s '/>' '\n'; done
	find . -name \*.xml | while read l
	do
		cat $l | python -c "import sys; import xml.etree.ElementTree as ET; import json; tree=ET.fromstring(sys.stdin.read()); menues=tree.findall('menuitem'); dump=json.dumps(map(lambda x: ET.tostring(x), menues), indent=4); print dump if len(dump) > 2 else ''" 2> /dev/null
	done | egrep '"' | less -S
	return 1
	find . -type f -name \*.xml | while read l
	do
		sed -n '/<menuitem/,/[^(/>)]*/p' $l 2> /dev/null | tr -s ' ' $'\n' | while read ll
		do
			if [ ! "$ll" = "<menuitem" ]
			then
				echo -e $(tr -s $'\n' ' ' <<< $ll)
			else
				echo -e "\n\n<menuitem"
			fi
		done
	done | less
}

MAVEN_HOME=/usr/share/maven2/

function nlocate() {
	read vars <<< "$@"
	vars=$(echo \*$(tr -s ' ' '*' <<< $vars)\*)
	# echo $vars
	locate $vars
}

function dirdepth() {
	egrep -o "^\.(/[^/]+){"$1"}"
}

function uncomment-xml() {
	xmlstarlet ed -d '//comment()' $1
}

function apt() {
    args=${@:2}
    case $1 in
	update)
	    apt-get      update        $args
	    ;;
	upgrade)
	    apt-get      upgrade       $args
	    ;;
	install)
	    apt-get      install       $args
	    ;;
	remove)
	    apt-get      remove        $args
	    ;;
	autoremove)
	    apt-get      autoremove    $args
	    ;;
	purge)
	    apt-get      purge         $args
	    ;;
	source)
	    apt-get      source        $args
	    ;;
	build)
	    apt-get      build         $args
	    ;;
	dist)
	    apt-get      dist          $args
	    ;;
	dselect)
	    apt-get      dselect       $args
	    ;;
	clean)
	    apt-get      clean         $args
	    ;;
	autoclean)
	    apt-get      autoclean     $args
	    ;;
	check)
	    apt-get      check         $args
	    ;;
	changelog)
	    apt-get      changelog     $args
	    ;;
	download)
	    apt-get      download      $args
	    ;;
	gencaches)
	    apt-cache    gencaches     $args
	    ;;
	showpkg)
	    apt-cache    showpkg       $args
	    ;;
	showsrc)
	    apt-cache    showsrc       $args
	    ;;
	stats)
	    apt-cache    stats         $args
	    ;;
	dump)
	    apt-cache    dump          $args
	    ;;
	dumpavail)
	    apt-cache    dumpavail     $args
	    ;;
	unmet)
	    apt-cache    unmet         $args
	    ;;
	search)
	    apt-cache    search        $args
	    ;;
	show)
	    apt-cache    show          $args
	    ;;
	depends)
	    apt-cache    depends       $args
	    ;;
	rdepends)
	    apt-cache    rdepends      $args
	    ;;
	pkgnames)
	    apt-cache    pkgnames      $args
	    ;;
	dotty)
	    apt-cache    dotty         $args
	    ;;
	xvcg)
	    apt-cache    xvcg          $args
	    ;;
	policy)
	    apt-cache    policy        $args
	    ;;
    esac
}

function filter-count-char() {
    if [ ! $2 ]
    then
	echo "this functions requires 2 variables"
	exit 1
    fi
    # 3 is color
    if [ ! $3 ]
    then
	while read l
	do
	    c=$(grep "$1" -c <<< $l)
	    if [ $c -gt "$2" ]
	    then
		echo $l
	    else
		# testing echo counter
		echo "$c  $1 "$(grep "$1" <<< $l --color=always)
	    fi
	done
    else
        while read l
        do
            c=$(grep "$1" -c <<< $l)
            if [ $c -gt "$2" ]
            then
                grep "$1" <<< $l --color=always
            fi
        done
    fi

}
function odoo-qweb-statement() {
    find . -type f -name \*.xml | while read l; do egrep -o " t\-[^=]+=\"[^\"]+\" " $l 2> /dev/null; done
}

function second() {
    eval "$@" 2>&1
}

function go-pkg-grep() {
    grep -oP "(?<=/usr/local/go/src/)([^/]+/){3,3}"
}

function go-pkg() {
    find $GOPATH/src -name \*.go
}

function multigrep() {
    # apply multiple grep filters
    # TODO
    #
    # TEST: echo -e "a x  x\nx x x " | multigrep a a a   da

    IFS=
    read filters <<< "$@"
    # echo $filters
    while read l
    do
	echo $l " << " $filters " >> "
    done
}

# standar go library
# custom libraries
GOPATH=$HOME/go
GOROOT=/usr/local/go

# /usr/lib/go/pkg/tool/linux_amd64/

PATH=$PATH:$GOROOT/bin

function kill-odoo() {
    lsof -i | grep python | grep LISTEN | grep ":80" | tr -s ' ' | cut -d ' ' -f2 | xargs -L1 kill -9
}

function clone() {
    dir=$(egrep -o "\w+$" <<< $(dirname $(egrep -o "(/[^/]+){2,2}$" <<< $1)))
    # echo $dir
    mkdir $dir
    cd $dir
    git clone $1
}

function python-exe() {
    grep -r "if __name__ == '__main__':" . | cut -d ':' -f1
}

function backup-all() {
    if [ -d $1 ]
    then
	find $1 -type f | egrep "[^~]$" | while read l
	do
	    # if file does not exist
	    if [ ! -f $l~ ]
	    then
		cp $l $l~
	    fi
	done
    fi
}

function shinken-bins() {
    ls /usr/lib/python2.7/dist-packages/shinken/bin/shinken* | egrep "/[^\.]+$"
}

function odoo-deps() {
    find -type f -name __openerp__.py -or -name __manifest__.py  | while read l
    do
	python2 -c "import os; import ast; f=open('"$l"', 'r'); obj=ast.literal_eval(f.read()); l = []; l.append(os.path.basename(os.path.dirname('"$l"'))); l.extend(obj['depends']); print l" 2> /dev/null
    done
}

function odoo-repeated() {
    odoo-deps | grep -oP "^..(?<=')[^']+'," | uniq -c | less
}

function odoo-field() {
    context=0
    # lines to show after the match
    if [ $2 ]
    then
	context=$2
    fi
    # $3 filter file by name
    if [ $3 ]
    then
	find . -type f -name \*.py | grep -i $3 | while read l; do egrep -nA $context "[^ ]*$1[^ ]*(['\"]: | = )fields" $l --color=always && echo $l; done | less -RS
    else
	find . -type f -name \*.py | while read l; do egrep -nA $context "[^ ]*$1[^ ]*(['\"]: | = )fields" $l --color=always && echo $l; done | less -RS
    fi
}

function repo() {
    find /root/clone -maxdepth 3 -type d | grep -i "$@"
}

function start-odoo-10() {
    python2 -c "import odoo; odoo.cli.main()"
}

odoo10=/usr/local/lib/python2.7/dist-packages/odoo-10.0.post20170303-py2.7.egg/odoo/

function bk_day_second() {
    # backup with date and second appended at the end
    if [ -d $1 ] || [ -f $1 ]
    then
	zip -r $1_$(date +"%D" | tr -s / _)_$(date +"%s" | tr -s / _).zip $1
    fi
}
function echo-ip-range() {
    start=127
    if [ $1 ]
    then
	start=$1
    fi
    seq $start | while read a
    do
	seq 127 | while read b
	do
	    seq 127 | while read c
	    do
		# sleep 0.1
		echo $a.$b.$c
	    done
	done
    done
}

function bind-names() {
    egrep -ir "[a-z]+\.[a-z]+\.[a-z]+" /etc/bind
}

function reload() {
    source ~/.bashrc
}

function xssh() {
    # forwards X11
    ssh -YX -o ForwardX11=yes -o ForwardX11Trusted=yes "$@"
}

function droid() {
    ssh usuario@192.168.69.101 -p 2222
}

function findodooclass() {
    if [ ! "$(basename $(pwd))" = 'addons' ]
    then
    	echo "ERROR: Pararse sobre el directorio de addons the odoo"
        return 1
    fi
    if [ ! -f all_py_files ]
    then
	find . | grep -E "\.py$" | tee all_py_files
    fi
    # if 2 is true meams that shows inherit models also
    if [ $2 ]
    then
        cat all_py_files | while read l; do grep -E "^[\t ]+(_name|_inherit)[\t ]*=[\t ]*['\"][^'\"]*$1[^'\"]*['\"][\t ]*" $l --color=always && echo $l;done | less -R
    else
        cat all_py_files | while read l; do grep -E "^[\t ]+_name[\t ]*=[\t ]*['\"][^'\"]*$1[^'\"]*['\"][\t ]*" $l --color=always && echo $l;done | less -R
    fi
}

# ls -d ingadhoc/*/*/__openerp__.py | xargs -L1 dirname | xargs -L1 basename | while read l; do ls ../odoo/addons/$l ;done

function odoo_packages_check() {
    cwd=$(pwd)
    if [ $1 ]
    then
	folder=$(grep -oE "\w+" <<< $1)
	if [ $(grep "/addons_extra$" <<< $cwd) ]
	then
	    if [ -d $folder ]
	    then
		echo ok
		folder2=$(grep -oE "\w+" <<< $2)
		if [ -d ${folder}/${folder2} ]
		then
		    folder=${folder}/${folder2}
		fi
		ls -d ${folder}/__openerp__.py | xargs -L1 dirname
	    else
		echo error
	    fi
	else
	    echo wrong path
	fi
    fi
}

function find-function() {
    cat ~/.bashrc | grep -oP "(?<=function )[^\(]+" | grep "$1"
}

function replace-bashrc() {
    user=root
    path=/${user}
    url=${user}@192.168.69.11
    file=${path}/.bashrc
    fullpath=$url:$file
    echo "Do you want to change ? (y / n): "
    echo $fullpath
    read ans
    if [ ! "$ans" = "y" ]
    then
	echo changing url to use ...
	read fullpath
    fi
    assert=$(grep "@" <<< $fullpath)
    assert=$(grep ":/" <<< $fullpath)
    # echo $assert
    if [ $(wc -l <<< $assert) -gt 0 ]
    then
	echo replacing bashrc ...
	chars=$(wc -c ~/.bashrc | cut -d ' ' -f1)
	if [ $chars -gt 500 ]
	then
	    command ssh $url "mv ~/.bashrc ~/.bashrc.old"
	    command scp ~/.bashrc $url:$file
	else
	    echo ~/.bashrc file is too small not replacing
	fi
    fi
}

function git-remotes() {
    find . -type d 2> /dev/null | grep -oP ".*(?=\.git)" | uniq | sort | uniq | while read l; do git -C "$l" remote -v | while read ll; do echo $l $ll ;done ;done | /usr/bin/column -t
}

function gittree() {
    git ls-tree --full-tree -r HEAD
}

function gitfiles() {
    gittree | column 3 | egrep -o "[^ 	]+$" --color=no
}

#function list() {
# if [ $1 =~ "file" ] || [ $1 ]
#}

alias car="cat"
alias pdw="pwd"

function opendir() {
    if [ -f $1 ]
    then
	# coomand to avoid alias
        command cd $(dirname $1)
    else
	if [ -d $1 ]
	then
	    # coomand to avoid alias
	    command cd $1
	fi
    fi
}

function miss_cd() {
    if [ -f $1 ] || [ -d $1 ]
    then
	opendir $1
    else
	if [ -f $2 ] || [ -d $2 ]
	then
	    opendir $1
	fi
    fi
}

alias cd="opendir"
alias c="miss_cd"
alias d="miss_cd"

function grep_field() {
    while read l
    do
        echo $l
        cat $l | /bin/grep -E "^\.|['\"]"$1".{1,3}fields" --color
    done
}

function find_field() {
    if [ $2 ]
    then
        odoo_model $1 | grep_field $2
    fi
}

function odoo_model() {
    if [ $1 ]
    then
        grep -rE "(_name|_inherit) = ['\"]"$1"['\"]" --color . | cut -d ':' -f1 | grep -E "[^~]$" | uniq | sort | uniq
    fi
}


function kill-them() {
    # tr -s ' ' | cut -d ' ' -f2
    if [ $1 ]
    then 
        tr -s ' ' | cut -d ' ' -f$1 | xargs -L1 sudo kill -9
    else
        tr -s ' ' | cut -d ' ' -f2 | xargs -L1 sudo kill -9
    fi
}

function bsort() {
    uniq | sort | uniq
}

function boot-services() {
    find /etc/rc*.d | grep -oP "(?<=/\w[0-9]{2}).*" | bsort
}

function psg() {
    ps aux | grep "$@" | grep -v grep
}

function search-pylib() {
    if [ $1 ]
    then
	ls -ld /usr/lib/python2.7/dist-packages/*/ | tr -s ' ' | cut -d ' ' -f9 | xargs -L1 basename |  grep -i "$1"
    else
	ls -ld /usr/lib/python2.7/dist-packages/*/ | tr -s ' ' | cut -d ' ' -f9 | xargs -L1 basename
    fi
}

function callemacs() {
    emacs -nw $@
}

alias emacs="callemacs"
alias emacs-gui="ignore /usr/bin/emacs"

function movetotrash() {
    if [ ! -f $1 ] && [ ! -d $1 ]
    then
	echo "\$1 has to be a file or directory: "$1
	return 1
    fi
    mv $1 ~/trash
    if [ $? -eq 0 ]
    then
	echo "move to trash ~/trash successfully"
    else
	echo -e "\033[31m cannot move to trash, do you want to force ?"
	echo -e "\033[39m"
	read ans </dev/tty
	if [ $ans = "y" ]
	then
	    # only a not empty directory cause an error
	    if [ ! -d ~/trash/$1 ]
	    then
		echo "the directory in trash does not exist: ~/trash/"$1
		return 1
	    fi
	    command rm -rf ~/trash/$1
	    mv $1 ~/trash
	    if [ $? -eq 0 ]
	    then
		echo "move to trash ~/trash successfully"
	    else
		echo -e "\033[31m an error ocurred exiting ..."
		echo -e "\033[39m"
		return 1
	    fi
	fi
    fi
}

alias rm="movetotrash"

function error-log () {
    case "$1" in
	kerio)
	    grep -iC 10 "error" /var/log/kerio-kvc/debug.log --color=always | grep -EC 20 "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" --color=always | less -R
	    ;;
	*)
	    echo "No existe el log para $1"
	    ;;
    esac
}

function kerio-change() {
    IFS=
    conn=$(cat /home/skyline/Development/kerio-kvc.conf | grep -A 8 "\-\- $1" | head -n 9 | sed -n '/<connect/,/<\/connect/p')
    echo -en "\n$conn"
    echo -en "\n\ndo you want to replace this into /etc/kerio-kvc ? (y / n):  "
    read ans
    conf=/etc/kerio-kvc.conf
    # ask the password for root
    sudo true
    # default is yes
    if [ "$ans" = "y" ] || [ -z "$ans" ]
    then
	echo
	echo "<config>"         | sudo tee    $conf  2> /dev/null
	echo "  <connections>"  | sudo tee -a $conf  2> /dev/null
	echo      $conn         | sudo tee -a $conf  2> /dev/null
	echo "  </connections>" | sudo tee -a $conf  2> /dev/null
	echo "</config>"        | sudo tee -a $conf  2> /dev/null
	echo
	echo "OK ..."
	echo
	echo -en "do you want to restart Kerio VPN Service ? (y / n):  "
	read ans
	if [ "$ans" = "y" ] || [ -z "$ans" ]
	then
	    echo
	    sudo service kerio-kvc restart  2> /dev/null
	    echo
	    echo "OK ..."
	else
	    echo "Canceled (restarting service) ..."
	fi
    else
	echo "Canceled (changing config) ..."
    fi
}

function crepeat() {
    seq $2 | while read l
    do
	echo -en "$1"
    done
}

function gitstat() {
    git diff --stat $1$(crepeat "^" $2) --color=always | grep -E "\.py |\.xml " --color=always
}

function maxstr () {
    if [ $1 ]
    then
	while read l
	do
	    echo $(l:0:$1)
	done
    else	
	while read l
	do
	    echo ${l:0:100}
	done
    fi
}

function findstr() {
    IFS=
    findext $1 | \
	while read l
    do
	gg=$(grep -iE "$2" $l --colors=auto)
	echo ${gg:0:100}
	# done | grep "\w" --color=auto | grep $2 --color=auto
    done | grep -i $2 --color=auto
}

function contains () {
    while read l
    do
	if [[ $(grep -i "$1" $l) ]]
	then
	    echo $l
	fi
    done
}

function rmpyc () {
    findext pyc | xargs -L1 rm
    find . | grep "\#.*\#" | xargs -L1 rm
}

function grepdirs() {
    if [ $1 ]
    then
	grep -oE "(/[\.a-zA-Z0-9\_\-]+)+" | dirs
    else
	grep -oE "(/[\.a-zA-Z0-9\_\-]+)+"
    fi
}

function dirsmax() {
	grep -oE "^(/[\.a-zA-Z0-9\_\-]+){1,"$1"}"
}


function ccgrep() {
    if [ ! $3 ]
    then
	echo `grep -E "$1" --color=always | less -RS`
    else
        echo `grep -E "$1" --color=always | less -RS | sed -e "s/^.*$/&1\n/"`
    fi
}


function getfields() {
    grep -oE "^[^=]+"  | tr -s ' ' | cut -d ' ' -f3 | sort | uniq
}

function local-ip () {
    ifconfig | grep -A 1 eth0 | grep -oP "(?<=addr:)[^ ]+"
}

function time_subfix() {
    echo $(date +"%d%m")_$(date +"%s")
}

function socket-like () {
    ss | grep $1 | column 5 | buniq
}

function columns () {
    tr -s ' ' | cut -d ' ' -f$1
}

function make-backup () {
    if [[ -d $1 ]]
    then
	diames=$(date +"%d%m")
	segundos=$(date +"%s")
	extra=$(whoami)_$(hostname)_$(local-ip)
	mkdir backups 2> /dev/null
	if [[ $(grep -E "/$" <<< $1) ]]
	then
	    echo "$1 has ////"
	    # correct=${1:0:$(( $(wc -c <<< $1) - 2 ))}
	    correct=$(echo $correct | grep -oE "[^/]+")
	    command=$(echo tar -cf backups/${correct}_${extra}_${diames}_${segundos}.tar.gz $1)
	    echo $command
	    eval $command
	else
	    echo "$1 does not have ////"
	    command=$(echo tar -cf backups/$1_${extra}_${diames}_${segundos}.tar.gz $1)
	    echo $command
	    eval $command
	fi
    fi
}

function dirs() {
    while read l
    do
	if [[ -f $1 ]] || [[ -d $1 ]]
	then
	    echo $l
	fi
    done
}

function get-odoo-password() {
    case "$1" in
	mera)
	    ssh mera -t "cat /etc/odoo/openerp-server.conf | grep admin_passwd"
	    ;;
	*)
	    echo "invalid option"
	    ;;
    esac
}

function findext() {
    if [ $2 ]
    then
	find $2 -type f | grep -E "\.$1$"
    else
	find . -type f | grep -E "\.$1$"
    fi
}

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
    *)
	;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
    fi
fi

source ~/.bash_custom

function killthem () {
    tr -s ' ' | cut -d ' ' -f2 | sudo xargs -L1 kill -9
}
