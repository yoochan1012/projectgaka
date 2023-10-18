#!/bin/bash

mkdir -p /check/U1~73/
mkdir -p /check/U1~73/log /check/U1~73/action /check/U1~73/bad /check/U1~73/good


##########[U-01]root 계정 원격 접속 제한##########


CF1=/etc/securetty
CF2=/etc/pam.d/login
pts=$(grep 'pts' $CF1 | grep -v '#')
pam=$(grep "/lib/security/pam_securetty.so" $CF2 | grep 'required' | awk '{print $1}')
#사용할 변수 선언

echo -e "##########[U-01]root 계정 원격 접속 제한##########\n[root 직접접속 차단 여부]" >> /check/U1~73/log/[U-01]log.txt
grep 'pts' $CF1 >> /check/U1~73/log/[U-01]log.txt
echo -e "\n[원격 터미널 서비스 사용 여부]" >> /check/U1~73/log/[U-01]log.txt
grep '/lib/security/pam_securetty.so' $CF2 | grep 'required' | grep 'auth' >> /check/U1~73/log/[U-01]log.txt
#로그파일에 출력에 대한 제목후 개행하여 길어도 보기 편하게 출력
cat /check/U1~73/log/[U-01]log.txt >> /check/U1~73/log.txt


if [[ $pam == 'auth' ]] || [[ -z $pts ]]; then
 echo -e "A|[U-01] 원격 터미널 서비스를 사용하지 않거나, 사용 시 root 직접 접속을 차단되어 있음 - [양호]" >> /check/U1~73/good/[U-01]good.txt
 cat /check/U1~73/good/[U-01]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-01] 원격 터미널 서비스 사용 시 root 직접 접속이 허용되어 있음 - [취약]" >> /check/U1~73/bad/[U-01]bad.txt
 cat /check/U1~73/bad/[U-01]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-01] vi 편집기를 사용하여 /etc/securetty 파일을 열어 pts/* 설정이 존재하는 경우 제거 또는 주석처리\nvi 편집기를 사용하여 /etc/pam.d/login 파일을 열어 auth required /lib/security/pam_securetty.so 설정이 없거나 주석처리 되어 있다면 신규 삽입 또는 주석 제거" >> /check/U1~73/action/[U-01]action.txt
 sed -e 's/\[U-01\] /\n\[(U-01)조치사항\]\n/g' /check/U1~73/action/[U-01]action.txt >> /check/U1~73/Action.txt
fi

##########[U-02]패스워드 복잡성 설정##########


CF1=/etc/pam.d/system-auth
CF2=/etc/login.defs

lcredit=$(grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | grep lcredit | awk -F= '{print $2}')
ucredit=$(grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | grep ucredit | awk -F= '{print $2}')
dcredit=$(grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | grep dcredit | awk -F= '{print $2}')
ocredit=$(grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | grep ocredit | awk -F= '{print $2}')
retry=$(grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | grep retry | awk -F= '{print $2}')
minlen=$(grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | grep minlen | awk -F= '{print $2}')
age=$(grep -i "pass" $CF2 | grep -v "#" | grep -i 'warn_age' | awk '{print $2}')
max_day=$(grep -i "pass" $CF2 | grep -v "#" | grep -i 'max_days' | awk '{print $2}')
min_day=$(grep -i "pass" $CF2 | grep -v "#" | grep -i 'min_days' | awk '{print $2}')
min_len=$(grep -i "pass" $CF2 | grep -v "#" | grep -i 'min_len' | awk '{print $2}')

echo -e "\n##########[U-02]패스워드 복잡성 설정##########\n[/etc/pam.d/system-auth 파일 설정]" >> /check/U1~73/log/[U-02]log.txt
grep "pam_cracklib.so" $CF1 | tr -s ' ' '\n' | sed '1,3d' >> /check/U1~73/log/[U-02]log.txt
echo -e "\n[/etc/login.defs 파일설정]" >> /check/U1~73/log/[U-02]log.txt
grep -i 'pass' /etc/login.defs | grep -v '#' >> /check/U1~73/log/[U-02]log.txt

cat /check/U1~73/log/[U-02]log.txt >> /check/U1~73/log.txt


if [[ $lcredit == -1 ]] && [[ $ucredit == -1 ]] && [[ $dcredit == -1 ]] && [[ $ocredit == -1 ]] && [[ $minlen -ge 8 ]] && [[ $retry == 3 ]] && [[ $age == 7 ]] && [[ $min_day -ge 1 ]] && [[ $max_day -le 60 ]] && [[ $min_len -ge 8 ]]; then
 echo -e "A|[U-02] /etc/pam.d/system-auth, /etc/login.defs 내용이 내부 정책에 맞도록 설정되어있음 - [양호]" >> /check/U1~73/good/[U-02]good.txt
 cat /check/U1~73/good/[U-02]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-02] /etc/pam.d/system-auth, /etc/login.defs 내용이 내부 정책에 맞도록 설정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-02]bad.txt
 cat /check/U1~73/bad/[U-02]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-02] vi 편집기로 /etc/pam.d/system-auth 파일을 열어\n retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1로 설정\nvi 편집기로 /etc/login.defs 파일을 열어\n pass_warn_age=7, pass_max_day=60, pass_min_day=1, pass_min_len=8로 설정 변경" >> /check/U1~73/action/[U-02]action.txt
 sed -e 's/\[U-02\] /\n\[(U-02)조치사항\]\n/g' /check/U1~73/action/[U-02]action.txt >> /check/U1~73/Action.txt

fi

##########[U-03]계정 잠금 임계값 설정##########

CF=/etc/pam.d/system-auth
DENY=$(grep -i "deny=" $CF | grep -v '#' | awk '{print $4}' | awk -F= '{if($2<6)print($0)}')

echo -e "\n##########[U-03]계정 잠금 임계값 설정##########\n[계정 잠금 임계값]" >> /check/U1~73/log/[U-03]log.txt ; grep "deny=" /etc/pam.d/system-auth | grep -v '#' | awk '{print $4}' >> /check/U1~73/log/[U-03]log.txt
cat /check/U1~73/log/[U-03]log.txt >> /check/U1~73/log.txt


if [[ -n $DENY ]]; then
 echo -e "A|[U-03] 계정 잠금 임계값이 5이하의 값으로 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-03]good.txt
 cat /check/U1~73/good/[U-03]good.txt >> /check/U1~73/inspect.txt

else
 echo -e "A|[U-03] 계정 잠금 임계값이 설정되어 있지 않거나, 5 이하의 값으로 설정되지 않음 - [취약]" >> /check/U1~73/bad/[U-03]bad.txt
 cat /check/U1~73/bad/[U-03]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-03] 계정 잠금 임계값을 5 이하로 설정\n deny 값을 5 이하의 값으로 설정" >> /check/U1~73/action/[U-03]action.txt
 sed -e 's/\[U-03\] /\n\[(U-03)조치사항\]\n/g' /check/U1~73/action/[U-03]action.txt >> /check/U1~73/Action.txt

fi

##########[U-04]패스워드 파일 보호##########

SD=/etc/shadow
PW=$(cat /etc/passwd | awk -F: '{if($2 != "x")print ($2)}')

echo -e "\n##########[U-04]패스워드 파일 보호##########\n[shadow 파일 존재 확인]" >> /check/U1~73/log/[U-04]log.txt
ls /etc | grep "shadow" >> /check/U1~73/log/[U-04]log.txt
echo -e "\n[패스워드 암호화 되지 않은 파일 확인]" >> /check/U1~73/log/[U-04]log.txt
$PW >> /check/U1~73/log/[U-04]log.txt

cat /check/U1~73/log/[U-04]log.txt >> /check/U1~73/log.txt


if [[ ! -e $SD ]] && [[ -n $PW ]]; then
 echo -e "A|[U-04] 쉐도우 패스워드를 사용하지 않고, 패스워드를 암호화하여 저장하지 않음 - [취약]" >> /check/U1~73/bad/[U-04]bad.txt
 cat /check/U1~73/bad/[U-04]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-04] #pwconv 명령어를 사용하여 쉐도우 패스워드 정책 적용" >> /check/U1~73/action/[U-04]action.txt
 sed -e 's/\[U-04\] /\n\[(U-04)조치사항\]\n/g' /check/U1~73/action/[U-04]action.txt >> /check/U1~73/Action.txt
else
 echo -e "A|[U-04] 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하고 있음 - [양호]" >> /check/U1~73/good/[U-04]good.txt
 cat /check/U1~73/good/[U-04]good.txt >> /check/U1~73/inspect.txt
fi

##########[U-05] root 홈, 패스 디렉토리 권한 및 패스 설정##########

path1=$(echo $PATH | tr -s ':' '\n' | sed -n -e '/^\./p')
#echo로 PATH변수 불러오기 | tr -s명령어로 :문자를 \n으로 변환 | .으로 시작하는 행 출력
path2=$(echo $PATH | grep '::')
#echo로 PATH변수 불러오기 | :: 포함여부 확인

echo -e "\n##########[U-05] root 홈, 패스 디렉토리 권한 및 패스 설정##########\n[PATH변수]\n$PATH" >> /check/U1~73/log/[U-05]log.txt
cat /check/U1~73/log/[U-05]log.txt >> /check/U1~73/log.txt

if [[ -z $path1 ]] && [[ -z $path2 ]] ; then		#-z는 문자열이 0인 경우
 echo -e "B|[U-05] PATH 환경변수에 \".\" or \"::\"이 맨 앞이나 중간에 포함되어 있지 않습니다. - [양호]" >> /check/U1~73/good/[U-05]good.txt
 cat /check/U1~73/good/[U-05]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "B|[U-05] PATH 환경변수에 \".\" or \"::\"이 맨 앞이나 중간에 포함되어 있습니다. - [취약]" >> /check/U1~73/bad/[U-05]bad.txt
 cat /check/U1~73/bad/[U-05]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-05] root 계정의 설정파일을 들어가서 PATH 변수 앞에 \".\"이나 \":\"이 맨 앞에 존재하지 않도록 변경" >> /check/U1~73/action/[U-05]action.txt
 sed -e 's/\[U-05\] /\n\[(U-05)조치사항\]\n/g' /check/U1~73/action/[U-05]action.txt >> /check/U1~73/Action.txt
fi


##########[U-06]파일 및 디렉토리 소유자 설정##########

NO=$(find / -nouser -o -nogroup -print 2>/dev/null) 
log=$(find / -nouser -o -nogroup -print 2>/dev/null | tr -s ' ' '\n')

echo -e "\n##########[U-06]파일 및 디렉토리 소유자 설정##########\n[소유자 및 그룹이 존재하지 않는 파일 및 디렉토리]\n$log" >> /check/U1~73/log/[U-06]log.txt
cat /check/U1~73/log/[U-06]log.txt >> /check/U1~73/log.txt


if [[ -z $NO ]]; then
 echo -e "B|[U-06] 소유자가 존재하지 않는 파일 및 디렉토리가 존재하지 않음 - [양호]" >> /check/U1~73/good/[U-06]good.txt
 cat /check/U1~73/good/[U-06]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "B|[U-06] 소유자가 존재하지 않는 파일 및 디렉토리가 존재 - [취약]" >> /check/U1~73/bad/[U-06]bad.txt
 cat /check/U1~73/bad/[U-06]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-06] 소유자가 존재하지 않는 파일 및 디렉토리 삭제 또는 소유자 변경 \n rm 명령어를 사용해 파일 및 디렉토리 삭제 \n chown 명령어를 사용해 소유자 및 그룹 변경" >> /check/U1~73/action/[U-06]action.txt
 sed -e 's/\[U-06\] /\n\[(U-06)조치사항\]\n/g' /check/U1~73/action/[U-06]action.txt >> /check/U1~73/Action.txt
fi

##########[U-07] /etc/passwd 파일 소유자 및 권한 설정##########

CF=/etc/passwd  
OWNER=$(ls -l /etc/passwd | awk '{print $3}')
PERM=$(stat /etc/passwd | sed -n '4p' | awk '{print$2}' | cut -c 3-5) 

echo -e "\n##########[U-07] /etc/passwd 파일 소유자 및 권한 설정##########\n[파일의 소유자 및 권한]\n/etc/passwd 파일의 소유자 : $OWNER 권한 : $PERM" >> /check/U1~73/log/[U-07]log.txt
cat /check/U1~73/log/[U-07]log.txt >> /check/U1~73/log.txt


if [ -f $CF ] ; then
 if [[ $OWNER = 'root' ]] && [[ $PERM -le 644 ]] ; then
  echo -e "B|[U-07] 파일의 소유자가 root이고, 권한이 644 이하입니다. - [양호]" >> /check/U1~73/good/[U-07]good.txt
  cat /check/U1~73/good/[U-07]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-07] 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-07]bad.txt
  cat /check/U1~73/bad/[U-07]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-07] /etc/passwd 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/passwd\n파일 권한 변경 -> #chmod 644 /etc/passwd" >> /check/U1~73/action/[U-07]action.txt
  sed -e 's/\[U-07\] /\n\[(U-07)조치사항\]\n/g' /check/U1~73/action/[U-07]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-07] /etc/passwd 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-07]bad.txt
 cat /check/U1~73/bad/[U-07]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-07] /etc/passwd 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-07]action.txt
 sed -e 's/\[U-07\] /\n\[(U-07)조치사항\]\n/g' /check/U1~73/action/[U-07]action.txt >> /check/U1~73/Action.txt
fi

##########[U-08] /etc/shadow 파일 소유자 및 권한 설정##########

CF=/etc/shadow  
OWNER=$(ls -l /etc/shadow | awk '{print $3}')
PERM=$(stat /etc/shadow | sed -n '4p' | awk '{print$2}' | cut -c 3-5) 

echo -e "\n##########[U-08] /etc/shadow 파일 소유자 및 권한 설정##########\n[파일의 소유자 및 권한]\n/etc/shadow 파일의 소유자 : $OWNER 권한 : $PERM" >> /check/U1~73/log/[U-08]log.txt
cat /check/U1~73/log/[U-08]log.txt >> /check/U1~73/log.txt


if [ -f $CF ] ; then
 if [[ $OWNER = 'root' ]] && [[ $PERM -le 400 ]] ; then
  echo -e "B|[U-08] 파일의 소유자가 root이고, 권한이 400 이하입니다. - [양호]" >> /check/U1~73/good/[U-08]good.txt
  cat /check/U1~73/good/[U-08]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-08] 파일의 소유자가 root가 아니거나, 권한이 400 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-08]bad.txt
  cat /check/U1~73/bad/[U-08]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-08] /etc/shadow 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/shadow\n파일 권한 변경 -> #chmod 644 /etc/shadow" >> /check/U1~73/action/[U-08]action.txt
  sed -e 's/\[U-08\] /\n\[(U-09)조치사항\]\n/g' /check/U1~73/action/[U-08]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-08] /etc/shadow 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-08]bad.txt
 cat /check/U1~73/bad/[U-08]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-08] /etc/shadow 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-08]action.txt
 sed -e 's/\[U-08\] /\n\[(U-08)조치사항\]\n/g' /check/U1~73/action/[U-08]action.txt >> /check/U1~73/Action.txt
fi

##########[U-09] /etc/hosts 파일 소유자 및 권한 설정##########

CF=/etc/hosts  
OWNER=$(ls -l /etc/hosts | awk '{print $3}')
PERM=$(stat /etc/hosts | sed -n '4p' | awk '{print$2}' | cut -c 3-5) 

echo -e "\n##########[U-09] /etc/hosts 파일 소유자 및 권한 설정##########\n[파일의 소유자 및 권한]\n/etc/hosts 파일의 소유자 : $OWNER 권한 : $PERM" >> /check/U1~73/log/[U-09]log.txt
cat /check/U1~73/log/[U-09]log.txt >> /check/U1~73/log.txt


if [ -f $CF ] ; then
 if [[ $OWNER = 'root' ]] && [[ $PERM -le 600 ]] ; then
  echo -e "B|[U-09] 파일의 소유자가 root이고, 권한이 600 이하입니다. - [양호]" >> /check/U1~73/good/[U-09]good.txt
  cat /check/U1~73/good/[U-09]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-09] 파일의 소유자가 root가 아니거나, 권한이 600 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-09]bad.txt
  cat /check/U1~73/bad/[U-09]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-09] /etc/hosts 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/hosts\n파일 권한 변경 -> #chmod 644 /etc/hosts" >> /check/U1~73/action/[U-09]action.txt
  sed -e 's/\[U-09\] /\n\[(U-11)조치사항\]\n/g' /check/U1~73/action/[U-09]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-09] /etc/hosts 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-09]bad.txt
 cat /check/U1~73/bad/[U-09]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-09] /etc/hosts 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-09]action.txt
 sed -e 's/\[U-09\] /\n\[(U-09)조치사항\]\n/g' /check/U1~73/action/[U-09]action.txt >> /check/U1~73/Action.txt
fi


##########[U-10]/etc/xinetd.conf 파일 소유자 및 권한 설정##########

CF=/etc/xinetd.conf
PERM=$(stat $CF | sed -n '4p' | awk '{print$2}' | cut -c 3-5)
OWNER=$(ls -l $CF | awk '{print $3}')

echo -e "\n##########[U-10]/etc/xinetd.conf 파일 소유자 및 권한 설정##########\n[/etc/xinetd.conf 파일의 소유자 및 권한]\n소유자:$OWNER , 권한:$PERM" >> /check/U1~73/log/[U-10]log.txt
cat /check/U1~73/log/[U-10]log.txt >> /check/U1~73/log.txt

if [[ -f $CF ]]; then
 if [[ $PERM == 600 ]] && [[ $OWNER == 'root' ]]; then
  echo -e "B|[U-10] xinetd.conf 파일의 소유자가 root이고, 권한이 600으로 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-10]good.txt
  cat /check/U1~73/good/[U-10]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-10] xinetd.conf 파일의 소유자가 root가 아니거나, 권한이 600으로 설정되어있지 않음 - [취약]" >> /check/U1~73/bad/[U-10]bad.txt
  cat /check/U1~73/bad/[U-10]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-10] chown, chmod 명령어를 사용하여 /etc/xinetd.conf 파일의 소유자 및 권한 변경 (소유자 root, 권한 600)" >> /check/U1~73/action/[U-10]action.txt
  sed -e 's/\[U-10\] /\n\[(U-10)조치사항\]\n/g' /check/U1~73/action/[U-10]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-10] /etc/xinetd.conf 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-10]bad.txt
 cat /check/U1~73/bad/[U-10]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-010] /etc/xinetd.conf 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-10]action.txt
 sed -e 's/\[U-10\] /\n\[(U-10)조치사항\]\n/g' /check/U1~73/action/[U-10]action.txt >> /check/U1~73/Action.txt
fi

##########[U-11] /etc/syslog.conf 파일 소유자 및 권한 설정##########

CF=/etc/rsyslog.conf  
OWNER=$(ls -l /etc/rsyslog.conf | awk '{print $3}')
PERM=$(stat /etc/rsyslog.conf | sed -n '4p' | awk '{print$2}' | cut -c 3-5)  

echo -e "\n##########[U-11] /etc/syslog.conf 파일 소유자 및 권한 설정##########\n[파일의 소유자 및 권한]\n/etc/rsyslog.conf 파일의 소유자 : $OWNER 권한 : $PERM" >> /check/U1~73/log/[U-11]log.txt
cat /check/U1~73/log/[U-11]log.txt >> /check/U1~73/log.txt

if [[ -f $CF ]]; then
 if [[ $OWNER = 'root' ]] || [[ $OWNER = 'bin' ]] || [[ $OWNER = 'sys' ]] && [[ $PERM -le 644 ]]; then
  echo -e "B|[U-11] 파일의 소유자가 root또는 bin또는 sys이고, 권한이 644 이하입니다. - [양호]" >> /check/U1~73/good/[U-11]good.txt
  cat /check/U1~73/good/[U-11]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-11] 파일의 소유자가 root또는 bin또는 sys가 아니고, 권한이 644이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-11]bad.txt
  cat /check/U1~73/bad/[U-11]bad.txt >> /check/U1~73/inspect.txt

   echo -e "[U-11] /etc/rsyslog.conf 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/rsyslog.conf 또는 chown bin /etc/syslog.conf 또는 chown sys /etc/rsyslog.conf\n파일 권한 변경 -> #chmod 644 /etc/syslog.conf" >> /check/U1~73/action/[U-11]action.txt
  sed -e 's/\[U-11\] /\n\[(U-11)조치사항\]\n/g' /check/U1~73/action/[U-11]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-11] /etc/rsyslog.conf 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-11]bad.txt
 cat /check/U1~73/bad/[U-11]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-11] /etc/rsyslog.conf 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-11]action.txt
 sed -e 's/\[U-11\] /\n\[(U-11)조치사항\]\n/g' /check/U1~73/action/[U-11]action.txt >> /check/U1~73/Action.txt
fi


##########[U-12] /etc/services 파일 소유자 및 권한 설정##########

CF=/etc/services  
OWNER=$(ls -l /etc/services | awk '{print $3}')
PERM=$(stat /etc/services | sed -n '4p' | awk '{print$2}' | cut -c 3-5)  

echo -e "\n##########[U-12] /etc/services 파일 소유자 및 권한 설정##########\n[파일의 소유자 및 권한]\n/etc/services 파일의 소유자 : $OWNER 권한 : $PERM" >> /check/U1~73/log/[U-12]log.txt
cat /check/U1~73/log/[U-12]log.txt >> /check/U1~73/log.txt

if [[ -f $CF ]]; then
 if [[ $OWNER = 'root' ]] || [[ $OWNER = 'bin' ]] || [[ $OWNER = 'sys' ]] && [[ $PERM -le 644 ]]; then
  echo -e "B|[U-12] 파일의 소유자가 root또는 bin또는 sys이고, 권한이 644 이하입니다. - [양호]" >> /check/U1~73/good/[U-12]good.txt
  cat /check/U1~73/good/[U-12]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-12] 파일의 소유자가 root또는 bin또는 sys가 아니고, 권한이 644이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-12]bad.txt
  cat /check/U1~73/bad/[U-12]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-12] /etc/services 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/services 또는 chown bin /etc/services 또는 chown sys /etc/services\n파일 권한 변경 -> #chmod 644 /etc/services" >> /check/U1~73/action/[U-12]action.txt
  sed -e 's/\[U-12\] /\n\[(U-12)조치사항\]\n/g' /check/U1~73/action/[U-12]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-12] /etc/services 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-12]bad.txt
 cat /check/U1~73/bad/[U-12]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-12] /etc/rsyslog.conf 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-12]action.txt
 sed -e 's/\[U-12\] /\n\[(U-12)조치사항\]\n/g' /check/U1~73/action/[U-12]action.txt >> /check/U1~73/Action.txt
fi

##########[U-13] SUID, SGID, Sticky bit 관련 설정 및 권한 설정##########

find=$(find / -type f -user root \( -perm -04000 -o -perm -02000 \) -exec ls -al {} \; 2>/dev/null | awk '{print ($1,$9)}')

echo -e "\n##########[U-13] SUID, SGID, Sticky bit 관련 설정 및 권한 설정##########\n[SUID, SGID 설정 부여되어 있는 파일]\n$find" >> /check/U1~73/log/[U-13]log.txt
cat /check/U1~73/log/[U-13]log.txt >> /check/U1~73/log.txt

if [[ -z $find ]]; then
 echo -e "B|[U-13] 주요 실행파일의 권한에 SUID와 SGID에 대한설정이 부여되어 있지 않음 - [양호]" >> /check/U1~73/good/[U-13]good.txt
 cat /check/U1~73/good/[U-13]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "B|[U-13] 주요 실행 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있음 - [취약]" >> /check/U1~73/bad/[U-13]bad.txt
 cat /check/U1~73/bad/[U-13]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-13] 1. 주요 실행파일에 대한 SUID/SGID 설정 여부 확인\n2. 애플리케이션에서 생성한 파일이나, 사용자가 임의로 생성한 파일 등 의심스럽거나 특이한 파일의 발견 시 SUID 제거 필요" >> /check/U1~73/action/[U-13]action.txt
 sed -e 's/\[U-13\] /\n\[(U-13)조치사항\]\n/g' /check/U1~73/action/[U-13]action.txt >> /check/U1~73/Action.txt
fi

##########[U-14] /etc/hosts 파일 소유자 및 권한 설정##########

PERM=$(find / -perm -o+w -type f \( -name "*.profile" -o -name "*.kshrc" -o -name "*.cshrc" -o -name "*.bashrc" -o -name "*.bash_profile" -o -name "*.login" -o -name "*.exrc" -o -name "*.netrc" \) -exec ls -al {} \; | awk '{print $1,$3,$9}')
OWNER=$(find / ! -user root -type f \( -name "*.profile" -o -name "*.kshrc" -o -name "*.cshrc" -o -name "*.bashrc" -o -name "*.bash_profile" -o -name "*.login" -o -name "*.exrc" -o -name "*.netrc" \) -exec ls -al {} \; | awk '{print $1,$3,$9}')

echo -e "\n##########[U-14] /etc/hosts 파일 소유자 및 권한 설정##########\n[홈 디렉토리 환경변수 파일의 소유자가 root가 아닌 파일]\n$OWNER\n\n[홈 디렉토리 환경변수 파일에 others에게 쓰기 권한이 부여 된 파일]\n$PERM" >> /check/U1~73/log/[U-14]log.txt
cat /check/U1~73/log/[U-14]log.txt >> /check/U1~73/log.txt

 if [[ -z $OWNER ]] && [[ -z $PERM ]] ; then
  echo -e "B|[U-14] 홈 디렉토리 환경변수 파일 소유자가 root로 지정되어 있고, 홈 디렉토리 환경변수 파일에 others에게 쓰기 권한이 부여되어 있지 않음. - [양호]" >> /check/U1~73/good/[U-14]good.txt
  cat /check/U1~73/good/[U-14]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-14] 홈 디렉토리 환경변수 파일 소유자가 root로 지정되어 있지 않거나, 홈 디렉토리 환경변수 파일에 others에게 쓰기 권한이 부여되어 있음. - [취약]" >> /check/U1~73/bad/[U-14]bad.txt
  cat /check/U1~73/bad/[U-14]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-14] 환경변수 파일의 소유자를 root 또는 파일 소유자로 지정 및 환경변수 파일의 권한 중 others 쓰기 권한 제거\n파일 소유자 변경 -> #chown <user_name> <file_name>\n파일 권한 변경 -> #chmod o-w <file_name>" >> /check/U1~73/action/[U-14]action.txt
  sed -e 's/\[U-14\] /\n\[(U-14)조치사항\]\n/g' /check/U1~73/action/[U-14]action.txt >> /check/U1~73/Action.txt
 fi

##########[U-15] world writable 파일 점검##########

PERM=$(find / -perm -o+w -type f -exec ls -al {} \; 2>/dev/null | awk '{print $1,$3,$9}')

echo -e "\n##########[U-15] world writable 파일 점검##########\n[world writable 파일]\n$PERM" >> /check/U1~73/log/[U-15]log.txt
cat /check/U1~73/log/[U-15]log.txt >> /check/U1~73/log.txt

 if [[ -z $PERM ]] ; then
  echo -e "B|[U-15] world writable 파일이 존재하지 않음. - [양호]" >> /check/U1~73/good/[U-15]good.txt
  cat /check/U1~73/good/[U-15]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-15] world writable 파일이 존재. - [취약]" >> /check/U1~73/bad/[U-15]bad.txt
  cat /check/U1~73/bad/[U-15]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-15] world writable 파일 권한 변경 또는 삭제\n파일 권한 변경 -> #chmod o-w <file_name>\n파일 삭제 -> #rm -rf <파일명>" >> /check/U1~73/action/[U-15]action.txt
  sed -e 's/\[U-15\] /\n\[(U-15)조치사항\]\n/g' /check/U1~73/action/[U-15]action.txt >> /check/U1~73/Action.txt
 fi

##########[U-16] /dev에 존재하지 않는 device 파일 점검##########

DEV=$(find /dev -type f -exec ls -l {} \; 2>/dev/null)

echo -e "\n##########[U-16] /dev에 존재하지 않는 device 파일 점검##########\n[dev에 존재하지 않는 파일]\n$DEV" >> /check/U1~73/log/[U-16]log.txt
cat /check/U1~73/log/[U-16]log.txt >> /check/U1~73/log.txt


if [[ -e $DEV ]] ; then
 echo -e "B|[U-16] /dev에 존재하지 않는 device파일이 존재합니다. - [취약]" >> /check/U1~73/bad/[U-16]bad.txt
 cat /check/U1~73/bad/[U-16]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-16] log파일을 보고 major, minor number를 가지지 않는 device파일을 찾아 제거하시오." >> /check/U1~73/action/[U-16]action.txt
 sed -e 's/\[U-16\] /\n\[(U-16)조치사항\]\n/g' /check/U1~73/action/[U-16]action.txt >> /check/U1~73/Action.txt
else
 echo -e "B|[U-16] /dev에 존재하지 않는 device파일이 존재하지 않습니다. - [양호]" >> /check/U1~73/good/[U-16]good.txt
 cat /check/U1~73/good/[U-16]good.txt >> /check/U1~73/inspect.txt
fi

##########[U-17] $HOME/.rhosts, hosts.equiv 사용 금지##########

CF=/etc/hosts.equiv
CF2=$HOME/.rhosts

OWNER=$(ls -l /etc/hosts.equiv 2>/dev/null | awk '{print $3}')
OWNER2=$(ls -l $HOME/.rhosts 2>/dev/null | awk '{print $3}')
PERM=$(stat /etc/hosts.equiv 2>/dev/null | sed -n '4p' | awk '{print$2}' | cut -c 3-5)
PERM2=$(stat $HOME/.rhosts 2>/dev/null | sed -n '4p' | awk '{print$2}' | cut -c 3-5)
PLUS=$(cat /etc/hosts.equiv 2>/dev/null | grep '\+')
PLUS2=$(cat $HOME/.rhosts 2>/dev/null | grep '\+')

echo -e "\n##########[U-17] $HOME/.rhosts, hosts.equiv 사용 금지##########\n[/etc/hosts.equiv 파일]\n소유자 : $OWNER, 권한 : $PERM, + 설정 존재 여부 : $PLUS\n[\$HOME/.rhosts 파일]\n소유자 : $OWNER2, 권한 : $PERM2, +설정 존재 여부 : $PLUS2" >> /check/U1~73/log/[U-17]log.txt
cat /check/U1~73/log/[U-17]log.txt >> /check/U1~73/log.txt


if [ -e $CF ] ; then		# /etc/hosts.equiv 파일이 존재
 if [[ $OWNER = 'root' ]] && [[ $PERM -le 600 ]] && [[ -z $PLUS ]]; then
  echo -e "B|[U-17] /etc/hosts.equiv 파일의 설정이 다음과 같습니다. 소유자가 'root', 권한이 600이하, 파일에서 "+" 설정이  존재하지 않음. - [양호]" >> /check/U1~73/good/[U-17]good.txt
  cat /check/U1~73/good/[U-17]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-17] /etc/hosts.equiv 파일의 설정이 다음과 같지 않습니다. 소유자가 'root', 권한이 600이하, 파일에서 "+" 설정이  존재하지 않음. - [취약]" >> /check/U1~73/bad/[U-17]bad.txt
  cat /check/U1~73/bad/[U-17]bad.txt >> /check/U1~73/inspect.txt

 echo -e "\n[U-17] [/etc/hosts.equiv 파일 소유자 변경 -> chown root /etc/hosts.equiv\n/etc/hosts.equiv 파일 권한 변경 -> chmod 600 /etc/hosts.equiv\nvi 편집기를 이용하여 \$HOME/.rhosts 파일에서 + 설정 제거 \n vi $HOME/.rhosts \n +를 제거하고 반드시 필요한 호스트 및 계정만 등록" >> /check/U1~73/action/[U-17]action.txt
  sed -e 's/\[U-17\] /\n\[(U-17)조치사항\]\n/g' /check/U1~73/action/[U-17]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-17] /etc/hosts.equiv 파일이 존재하지 않습니다. - [양호]" >> /check/U1~73/good/[U-17]good.txt
 cat /check/U1~73/good/[U-17]good.txt >> /check/U1~73/inspect.txt
fi


if [ -e $CF2 ] ; then		# \$HOME/.rhosts 파일이 존재"
 if [[ $OWNER2 = 'root' ]] && [[ $PERM2 -le 600 ]] && [[ -z $PLUS2 ]] ; then
  echo -e "B|[U-17] \$HOME/.rhosts 파일의 설정이 다음과 같습니다. 소유자가 'root', 권한이 600이하, 파일에서 "+" 설정이  존재하지 않음. - [양호]" >> /check/U1~73/good/[U-17]good.txt
  cat /check/U1~73/good/[U-17]good.txt | tail -1  >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-17] \$HOME/.rhosts 파일의 설정이 다음과 같지 않습니다. 소유자가 'root', 권한이 600이하, 파일에서 "+" 설정이  존재하지 않음. - [취약]" >> /check/U1~73/bad/[U-17]bad.txt
  cat /check/U1~73/bad/[U-17]bad.txt | tail -1  >> /check/U1~73/inspect.txt

  echo -e "[U-17] \$HOME/.rhosts 파일 소유자 변경 -> chown root \$HOME/.rhosts\n\$HOME/.rhosts 파일 권한 변경 -> chmod 600 \$HOME/.rhosts\nvi 편집기를 이용하여 \$HOME/.rhosts 파일에서 + 설정 제거 \n vi $HOME/.rhosts \n +를 제거하고 반드시 필요한 호스트 및 계정만 등록" >> /check/U1~73/action/[U-17]action.txt
  sed -e 's/\[U-17\] /\n\[(U-17)조치사항\]\n/g' /check/U1~73/action/[U-17]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-17] \$HOME/.rhosts 파일이 존재하지 않습니다. - [양호]" >> /check/U1~73/good/[U-17]good.txt
 cat /check/U1~73/good/[U-17]good.txt | tail -1 >> /check/U1~73/inspect.txt
fi

##########[U-18] 접속 IP 및 포트 제한##########

CF=/etc/hosts.deny
CF2=/etc/hosts.allow

DENY=$(sed '/^#/d' $CF | grep 'ALL\:ALL')
ALLOW=$(sed '/^#/d' $CF2 | sed 's/[^0-9]//g')

echo -e "\n##########[U-18] 접속 IP 및 포트 제한##########\n[DENY 여부(빈칸이면 설정 X)] : $DENY \n 허용 IP : $ALLOW" >> /check/U1~73/log/[U-18]log.txt
cat /check/U1~73/log/[U-18]log.txt >> /check/U1~73/log.txt

if [[ -n $DENY ]] && [[ -n $ALLOW ]] ; then
 echo -e "B|[U-18] /etc/hosts.deny파일에 ALL DENY 설정이 되어 있고, 접속을 허용할 특정 호스트에 대한 IP주소 및 포트 제한이 설정되어 있습니다. - [양호]" >> /check/U1~73/good/[U-18]good.txt
 cat /check/U1~73/good/[U-18]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "B|[U-18] /etc/hosts.deny 파일에 ALL DENY 설정되어 있지 않거나, 접속을 허용할 특정 호스트에 대한 IP주소 및 포트 제한이 설정되어 있지 않습니다. - [취약]" >> /check/U1~73/bad/[U-18]bad.txt
 cat /check/U1~73/bad/[U-18]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-18] vi 편집기를 이용해 /etc/hosts.deny 파일에 ALL DENY 설정 후 /etc/hosts.allow 파일에 접속 허용할 IP 및 포트 추가(해당 파일이 없을 경우 생성) " >> /check/U1~73/action/[U-18]action.txt
 sed -e 's/\[U-18\] /\n\[(U-18)조치사항\]\n/g' /check/U1~73/action/[U-18]action.txt >> /check/U1~73/Action.txt
fi

##########[U-19] Finger 서비스 비활성화##########

CF=/etc/xinetd.d/finger
FINGER=$(awk '/disable/' $CF)
FINGER_DISABLE=$(awk '/disable/' $CF | grep 'yes')

echo -e "\n##########[U-19] Finger 서비스 비활성화##########\n[finger 서비스 비활성화 여부]\n$FINGER" >> /check/U1~73/log/[U-19]log.txt
cat /check/U1~73/log/[U-19]log.txt >> /check/U1~73/log.txt


if [[ -n $FINGER_DISABLE ]] ; then
 echo -e "C|[U-19] finger 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-19]good.txt
 cat /check/U1~73/good/[U-19]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-19] finger 서비스가 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-19]bad.txt
 cat /check/U1~73/bad/[U-19]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-19] vi 편집기를 이용하여 /etc/xinetd.d/finger 파일 열고, disable = yes 로 설정\n xinetd 서비스 재시작\n service xinetd restart" >> /check/U1~73/action/[U-19]action.txt
 sed -e 's/\[U-19\] /\n\[(U-19)조치사항\]\n/g' /check/U1~73/action/[U-19]action.txt >> /check/U1~73/Action.txt
fi

##########[U-20] Anonymous FTP 비활성화##########

CF=/etc/vsftpd/vsftpd.conf
FTP=$(awk '/anonymous_enable/' $CF)
FTP_ENABLE=$(awk '/anonymous_enable/' $CF | grep 'yes')

echo -e "\n##########[U-20] Anonymous FTP 비활성화##########\n[anonymous FTP 활성화 여부]\n$FTP" >> /check/U1~73/log/[U-20]log.txt
cat /check/U1~73/log/[U-20]log.txt >> /check/U1~73/log.txt


if [ -n $FTP_ENABLE ]; then
 echo -e "C|[U-20] Anonymous FTP (익명 ftp) 접속이 차단되어있지 않음 - [취약]" >> /check/U1~73/bad/[U-20]bad.txt
 cat /check/U1~73/bad/[U-20]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-20] Anonymous FTP를 사용하지 않는 경우 Anonymous FTP 접속 차단 설정 적용\n vi /etc/vsftpd/vsftpd.conf\n anonymous_enable 을 no로 설정" >> /check/U1~73/action/[U-20]action.txt
 sed -e 's/\[U-20\] /\n\[(U-20)조치사항\]\n/g' /check/U1~73/action/[U-20]action.txt >> /check/U1~73/Action.txt
else
 echo -e "C|[U-20] Anonymous FTP (익명 ftp) 접속이 차단되어 있음 - [양호]" >> /check/U1~73/good/[U-20]good.txt
 cat /check/U1~73/good/[U-20]good.txt >> /check/U1~73/inspect.txt
fi

##########[U-21] r 계열 서비스 비활성화##########

rrr=$(ls -alL /etc/xinetd.d/* | egrep "rsh|rlogin|rexec" | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}')
rsh=$(grep -i 'disable' /etc/xinetd.d/rsh | awk -F= '{print $2}')
rlog=$(grep -i 'disable' /etc/xinetd.d/rlogin | awk -F= '{print $2}')
rex=$(grep -i 'disable' /etc/xinetd.d/rexec | awk -F= '{print $2}')

echo -e "\n##########[U-21] r 계열 서비스 비활성화##########\n[존재하는 r계열 서비스 파일]\n$rrr" >> /check/U1~73/log/[U-21]log.txt; echo -e "\n[r계열 서비스 비활성화 여부]\nrsh 비활성화 : $rsh\nrlog 비활성화 : $rlog\nrexec비활성화 : $rex" >> /check/U1~73/log/[U-21]log.txt
cat /check/U1~73/log/[U-21]log.txt >> /check/U1~73/log.txt

if [[ -n $rrr ]]; then
 if [[ $rsh =~ "yes" ]] && [[ $rlog =~ "yes" ]] && [[ $rex =~ "yes" ]]; then
  echo -e "C|[U-21] r 계열 서비스 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-21]good.txt
  cat /check/U1~73/good/[U-21]good.txt >> /check/U1~73/inspect.txt
 else 
  echo -e "C|[U-21] r 계열 서비스 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-21]bad.txt
  cat /check/U1~73/bad/[U-21]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-21] /etc/xinetd.d/ 디렉토리 내 rsh, rlogin, rexec 파일을 열고 Disable = yes 설정" >> /check/U1~73/action/[U-21]action.txt
  sed -e 's/\[U-21\] /\n\[(U-21)조치사항\]\n/g' /check/U1~73/action/[U-21]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "C|[U-21] r 계열 서비스 활성화 되지 않음 - [양호]" >> /check/U1~73/good/[U-21]good.txt
 cat /check/U1~73/good/[U-21]good.txt >> /check/U1~73/inspect.txt
fi

##########[U-22] cron파일 소유자 및 권한 설정##########

CF1=/etc/cron.allow
CF2=/etc/cron.deny

OWNER1=$(ls -l /etc | grep 'cron' | grep 'allow' | awk '{print $3}')
OWNER2=$(ls -l /etc | grep 'cron' | grep 'deny' | awk '{print $3}')
PERM1=$(stat /etc/cron.allow 2>/dev/null | sed -n '4p' | awk '{print $2}' | cut -c 3-5)
PERM2=$(stat /etc/cron.deny 2>/dev/null | sed -n '4p' | awk '{print $2}' | cut -c 3-5)

echo -e "\n##########[U-22] cron파일 소유자 및 권한 설정##########\n[파일의 소유자 및 권한]\n/etc/cron.allow 파일의 소유자 : $OWNER1 권한 : $PERM1 \n/etc/cron.deny 파일의 소유자 : $OWNER2 권한 : $PERM2" >> /check/U1~73/log/[U-22]log.txt
cat /check/U1~73/log/[U-22]log.txt >> /check/U1~73/log.txt


if [[ -f $CF1 ]] ; then
 if [[ $OWNER1 = 'root' ]] && [[ $PERM1 -le 640 ]]; then
  echo -e "C|[U-22] cron.allow 파일의 소유자가 root이고, 권한이 640 이하입니다. - [양호]" >> /check/U1~73/good/[U-22]good.txt
  cat /check/U1~73/good/[U-22]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "C|[U-22] cron.allow 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-22]bad.txt
  cat /check/U1~73/bad/[U-22]bad.txt >> /check/U1~73/inspect.txt

   echo -e "[U-22] /etc/cron.allow 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/cron.allow\n파일 권한 변경 -> #chmod 640 /etc/cron.allow" >> /check/U1~73/action/[U-22]action.txt
  sed -e 's/\[U-22\] /\n\[(U-22)조치사항\]\n/g' /check/U1~73/action/[U-22]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "C|[U-22] cron.allow 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-22]bad.txt
 cat /check/U1~73/bad/[U-22]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-22] cron.allow 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-22]action.txt
 sed -e 's/\[U-22\] /\n\[(U-22)조치사항\]\n/g' /check/U1~73/action/[U-22]action.txt >> /check/U1~73/Action.txt
fi


if [[ -f $CF2 ]] ; then
 if [[ $OWNER2 = 'root' ]] && [[ $PERM2 -le 640 ]]; then
  echo -e "C|[U-22] cron.deny 파일의 소유자가 root이고, 권한이 640 이하입니다. - [양호]" >> /check/U1~73/good/[U-22]good.txt
  cat /check/U1~73/good/[U-22]good.txt | tail -1 >> /check/U1~73/inspect.txt
 else
  echo -e "C|[U-22] cron.deny 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-22]bad.txt
  cat /check/U1~73/bad/[U-22]bad.txt | tail -1 >> /check/U1~73/inspect.txt
   echo -e "[U-22] /etc/cron.deny 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/cron.deny\n파일 권한 변경 -> #chmod 640 /etc/cron.deny" >> /check/U1~73/action/[U-22]action.txt
  sed -e 's/\[U-22\] /\n\[(U-22)조치사항\]\n/g' /check/U1~73/action/[U-22]action.txt | tail -3 >> /check/U1~73/Action.txt
 fi
else
 echo -e "C|[U-22] cron.deny 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-22]bad.txt
 cat /check/U1~73/bad/[U-22]bad.txt | tail -1 >> /check/U1~73/inspect.txt
 echo -e "[U-22] cron.deny 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-22]action.txt
 sed -e 's/\[U-22\] /\n\[(U-22)조치사항\]\n/g' /check/U1~73/action/[U-22]action.txt | tail -1 >> /check/U1~73/Action.txt
fi

##########[U-23] Dos 공격에 취약한 서비스 비활성화##########

echod=$(grep -i 'disable' /etc/xinetd.d/echo-dgram | awk -F= '{if($2 ~ /yes/) print "yes"}')
echos=$(grep -i 'disable' /etc/xinetd.d/echo-stream | awk -F= '{if($2 ~ /yes/) print "yes"}')
discardd=$(grep -i 'disable' /etc/xinetd.d/discard-dgram | awk -F= '{if($2 ~ /yes/) print "yes"}')
discards=$(grep -i 'disable' /etc/xinetd.d/discard-stream | awk -F= '{if($2 ~ /yes/) print "yes"}')
daytimed=$(grep -i 'disable' /etc/xinetd.d/daytime-dgram | awk -F= '{if($2 ~ /yes/) print "yes"}')
daytimes=$(grep -i 'disable' /etc/xinetd.d/daytime-stream | awk -F= '{if($2 ~ /yes/) print "yes"}')
chargend=$(grep -i 'disable' /etc/xinetd.d/chargen-dgram | awk -F= '{if($2 ~ /yes/) print "yes"}')
chargens=$(grep -i 'disable' /etc/xinetd.d/chargen-stream | awk -F= '{if($2 ~ /yes/) print "yes"}')

echo -e "\n##########[U-23] Dos 공격에 취약한 서비스 비활성화##########\n[echo 서비스 비활성화 여부]\n echo-dgram disable : $echod\n echo-stram disable : $echos\n\n[discard 서비스 비활성화 여부]\n discard-dgram disable : $discardd\n discard-stram disable : $discards\n\n[daytime 서비스 비활성화 여부]\n daytime-dgram disable : $daytimed\n daytime-stram disable : $daytimes\n\n[chargen 서비스 비활성화 여부]\n chargen-dgram disable : $chargend\n chargen-stram disable : $chargens" >> /check/U1~73/log/[U-23]log.txt
cat /check/U1~73/log/[U-23]log.txt >> /check/U1~73/log.txt

 if [[ $echod == "yes" ]] && [[ $echos == "yes" ]] && [[ $discardd == "yes" ]] && [[ $discards == "yes" ]] &&[[ $daytimed == "yes" ]] && [[ $daytimes == "yes" ]] && [[ $chargend == "yes" ]] && [[ $chargens == "yes" ]] ; then
  echo -e "C|[U-23] 사용하지 않는 DoS 공격에 취약한 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-23]good.txt
  cat /check/U1~73/good/[U-21]good.txt >> /check/U1~73/inspect.txt
 else 
  echo -e "C|[U-23] 사용하지 않는 DoS 공격에 취약한 서비스 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-23]bad.txt
  cat /check/U1~73/bad/[U-21]bad.txt >> /check/U1~73/inspect.txt
  echo -e "[U-23] vi 편집기를 이용해 "/etc/xinetd.d/" 디렉토리 내 echo, discard, daytime, chargen의 -dgram, stream 파일에 들어가 disable = yes 설정" >> /check/U1~73/action/[U-21]action.txt
  sed -e 's/\[U-23\] /\n\[(U-23)조치사항\]\n/g' /check/U1~73/action/[U-23]action.txt >> /check/U1~73/Action.txt
 fi


##########[U-24] NFS 서비스 비활성화##########

nfs=$(systemctl status nfs | grep 'Active' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')

echo -e "\n##########[U-24] NFS 서비스 비활성화##########\n[nfs 서비스 활성화 여부] : $nfs" >> /check/U1~73/log/[U-24]log.txt
cat /check/U1~73/log/[U-24]log.txt >> /check/U1~73/log.txt

if [[ $nfs =~ "dead" ]] ; then
 echo -e "C|[U-24] NFS 서비스 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-24]good.txt
 cat /check/U1~73/good/[U-24]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-24] NFS 서비스 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-24]bad.txt
 cat /check/U1~73/bad/[U-24]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-24] /etc/dfs/dfstab의 모든 공유 제거\nkill -9 명령어로 NFS 데몬(nfsd, statd, mountd, lockd) 중지\nrm 명령어로 시동 스크립트 삭제 또는 mv 명령어로 스크립트 이름 변경" >> /check/U1~73/action/[U-24]action.txt
 sed -e 's/\[U-24\] /\n\[(U-24)조치사항\]\n/g' /check/U1~73/action/[U-24]action.txt >> /check/U1~73/Action.txt
fi

##########[U-25] NFS 접근 통제##########

exports=$(cat /etc/exports)
insecure=$(grep 'insecure' /etc/exports)
nfs=$(systemctl status nfs | grep 'Active' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')

echo -e "\n##########[U-25] NFS 접근 통제##########\n[NFS 서비스 활성화 여부] : $nfs\n\n[/etc/exports 설정]\n$exports" >> /check/U1~73/log/[U-25]log.txt
cat /check/U1~73/log/[U-25]log.txt >> /check/U1~73/log.txt


if [[ $nfs =~ "dead" ]] || [[ -n $exports ]] && [[ -z $insecure ]]; then
 echo -e "C|[U-25] NFS 서비스 비활성화 되어 있거나, 사용 시 everyone 공유가 제한되어 있음 - [양호]" >> /check/U1~73/good/[U-25]good.txt
 cat /check/U1~73/good/[U-25]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-25] NFS 서비스 비활성화 되어 있지 않고, everyone 공유가 제한되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-25]bad.txt
 cat /check/U1~73/bad/[U-25]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-25] /etc/dfs/dfstab의 모든 공유 제거\nkill -9 명령어로 NFS 데몬(nfsd, statd, mountd, lockd) 중지\nrm 명령어로 시동 스크립트 삭제 또는 mv 명령어로 스크립트 이름 변경\n\n불가피하게 NFS 서비스 사용 시 NFS 접근제어 파일에 꼭 필요한 공유 디렉토리만 나열하고, everyone으로 시스템이 마운트 되지 않도록 설정\n옵션에 인증되지 않은 액세스를 허용하는 insecure 구문 설정 금지" >> /check/U1~73/action/[U-25]action.txt
 sed -e 's/\[U-25\] /\n\[(U-25)조치사항\]\n/g' /check/U1~73/action/[U-25]action.txt >> /check/U1~73/Action.txt
fi

##########[U-26] automountd 제거##########

autofs=$(systemctl status autofs | sed -n '3p' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')

echo -e "\n##########[U-26] automountd 제거##########\n[automountd 서비스 활성화 여부] : $autofs" >> /check/U1~73/log/[U-26]log.txt
cat /check/U1~73/log/[U-26]log.txt >> /check/U1~73/log.txt

if [[ $autofs =~ "dead" ]] ; then
 echo -e "C|[U-26] automountd 서비스 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-26]good.txt
 cat /check/U1~73/good/[U-26]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-26] automountd 서비스 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-26]bad.txt
 cat /check/U1~73/bad/[U-26]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-26] kill -9 [PID] 명령어로 automountd 데몬 중지\nrm 명령어로 시동 스크립트 삭제 또는 mv 명령어로 스크립트 이름 변경\n1.위치 확인 : #ls -al /etc/rc.d/rc*.d/* | grep automount (or autofs)\n2. 이름 변경 : #mv /etc/rc.d/rc2.d/S28automountd /etc/rc.d/rc2.d/_S28automountd" >> /check/U1~73/action/[U-26]action.txt
 sed -e 's/\[U-26\] /\n\[(U-26)조치사항\]\n/g' /check/U1~73/action/[U-26]action.txt >> /check/U1~73/Action.txt
fi


##########[U-27]RPC 서비스 확인##########

rpc_cmsd=$(grep -i 'disable' /etc/xinetd.d/rpc.cmsd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rpc_ttdbserverd=$(grep -i 'disable' /etc/xinetd.d/rpc.ttdbserverd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rpc_nisd=$(grep -i 'disable' /etc/xinetd.d/rpc.nisd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rpc_pcnfsd=$(grep -i 'disable' /etc/xinetd.d/rpc.pcnfsd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rpc_statd=$(grep -i 'disable' /etc/xinetd.d/rpc.statd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rpc_rquotad=$(grep -i 'disable' /etc/xinetd.d/rpc.rquotad | awk -F= '{if($2 ~ /yes/) print "yes"}')
sadmind=$(grep -i 'disable' /etc/xinetd.d/sadmind | awk -F= '{if($2 ~ /yes/) print "yes"}')
ruserd=$(grep -i 'disable' /etc/xinetd.d/ruserd | awk -F= '{if($2 ~ /yes/) print "yes"}')
walld=$(grep -i 'disable' /etc/xinetd.d/walld | awk -F= '{if($2 ~ /yes/) print "yes"}')
sprayd=$(grep -i 'disable' /etc/xinetd.d/sprayd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rstatd=$(grep -i 'disable' /etc/xinetd.d/rstatd | awk -F= '{if($2 ~ /yes/) print "yes"}')
rexd=$(grep -i 'disable' /etc/xinetd.d/rexd | awk -F= '{if($2 ~ /yes/) print "yes"}')
k_server=$(grep -i 'disable' /etc/xinetd.d/kcms_server | awk -F= '{if($2 ~ /yes/) print "yes"}')
cachefsd=$(grep -i 'disable' /etc/xinetd.d/cachefsd | awk -F= '{if($2 ~ /yes/) print "yes"}')

echo -e "\n##########[U-27]RPC 서비스 확인##########\n[RPC 서비스 비활성화 여부]\n rpc.cmsd disable : $rpc_cmsd\n rpc.ttdbserverd disable : $rpc_ttdbserverd\n rpc.nisd disable : $rpc_nisd\n rpc.pcnfsd disable : $rpc_pcnfsd\n rpc.statd disable : $rpc_statd\n rpc.rquotad disable : $rpc_rquotad\n sadmind disable : $sadmind\n ruserd disable : $ruserd\n walld disable : $walld\n sprayd disable : $sprayd\n rstatd disable : $rstatd\n rexd disable : $rexd\n kcms_server disable : $k_server\n cachefsd disable : $cachefsd" >> /check/U1~73/log/[U-27]log.txt
cat /check/U1~73/log/[U-27]log.txt >> /check/U1~73/log.txt


if [[ $rpc_cmsd =~ "yes" ]] && [[ $rpc_ttdbserverd =~ "yes" ]] && [[ $rpc_nisd =~ "yes" ]] && [[ $rpc_pcnfsd =~ "yes" ]] && [[ $rpc_statd =~ "yes" ]] && [[ $rpc_rquotad =~ "yes" ]] && [[ $sadmind =~ "yes" ]] && [[ $ruserd =~ "yes" ]] && [[ $walld =~ "yes" ]] && [[ $sprayd =~ "yes" ]] && [[ $rstatd =~ "yes" ]] && [[ $rexd =~ "yes" ]] && [[ $k_server =~ "yes" ]] && [[ $cachefsd =~ "yes" ]] ; then
  echo -e "C|[U-27] 불필요한 RPC 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-27]good.txt
  cat /check/U1~73/good/[U-27]good.txt >> /check/U1~73/inspect.txt
 else 
  echo -e "C|[U-27] 불필요한 RPC 서비스가 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-27]bad.txt
  cat /check/U1~73/bad/[U-27]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-27] vi 편집기를 이용해 /etc/xinetd.d/ 디렉토리 내 rpc.cmsd, rpc,ttdbserverd, rpc.nisd, rpc.pcnfsd, rpc.statd, rpc.rquotad, sadmind, ruserd, walld, sprayd, rstatd, rexd, kcms_server, cachefsd 파일에 들어가 disable = yes 설정" >> /check/U1~73/action/[U-27]action.txt
  sed -e 's/\[U-27\] /\n\[(U-27)조치사항\]\n/g' /check/U1~73/action/[U-27]action.txt >> /check/U1~73/Action.txt
 fi


##########[U-28] NIS, NIS+ 점검##########

NIS=$(ps -ef | egrep "ypserv|ypbind|ypxfrd|rpc.tppasswdd|rpc.tyupdated" | grep -v "grep -E")

echo -e "\n##########[U-28] NIS, NIS+ 점검##########\n[활성화 되어 있는 NIS, NIS+ 서비스] : $NIS" >> /check/U1~73/log/[U-28]log.txt
cat /check/U1~73/log/[U-28]log.txt >> /check/U1~73/log.txt

if [[ -z $NIS ]] ; then
 echo -e "C|[U-28] NIS, NIS+ 서비스 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-28]good.txt
 cat /check/U1~73/good/[U-28]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-28] NIS, NIS+ 서비스 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-28]bad.txt
 cat /check/U1~73/bad/[U-28]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-28] kill -9 [PID] 명령어로 NIS, NIS+ 데몬 중지\nrm 명령어로 시동 스크립트 삭제 또는 mv 명령어로 스크립트 이름 변경\n1.위치 확인 : #ls -al /etc/rc.d/rc*.d/* | egrep "ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated"\n2. 이름 변경 : #mv /etc/rc.d/rc2.d/S73ypbind /etc/rc.d/rc2.d/_S73ypbind" >> /check/U1~73/action/[U-28]action.txt
 sed -e 's/\[U-28\] /\n\[(U-28)조치사항\]\n/g' /check/U1~73/action/[U-28]action.txt >> /check/U1~73/Action.txt
fi

##########[U-29] tftp, talk 서비스 비활성화##########

tftp=$(grep -i 'disable' /etc/xinetd.d/tftp | awk -F= '{if($2 ~ /yes/) print "yes"}')
talk=$(grep -i 'disable' /etc/xinetd.d/talk | awk -F= '{if($2 ~ /yes/) print "yes"}')
ntalk=$(grep -i 'disable' /etc/xinetd.d/ntalk | awk -F= '{if($2 ~ /yes/) print "yes"}')

echo -e "\n##########[U-29] tftp, talk 서비스 비활성화##########\n[tftp, talk, ntalk 서비스 비활성화 여부]\n tftp disable : $tftp\n talk disable : $talk\n ntalk disable : $ntalk">> /check/U1~73/log/[U-29]log.txt
cat /check/U1~73/log/[U-29]log.txt >> /check/U1~73/log.txt

 if [[ $tftp == "yes" ]] && [[ $talk == "yes" ]] && [[ $ntalk == "yes" ]] ; then
  echo -e "C|[U-29] tftp, talk, ntalk 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-29]good.txt
  cat /check/U1~73/good/[U-29]good.txt >> /check/U1~73/inspect.txt
 else 
  echo -e "C|[U-29] tftp, talk, ntalk 서비스가 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-29]bad.txt
  cat /check/U1~73/bad/[U-29]bad.txt >> /check/U1~73/inspect.txt

  echo -e "[U-29] vi 편집기를 이용해 "/etc/xinetd.d/" 디렉토리 내 tftp, talk, ntalk 파일에 들어가 disable = yes 설정" >> /check/U1~73/action/[U-29]action.txt
  sed -e 's/\[U-29\] /\n\[(U-29)조치사항\]\n/g' /check/U1~73/action/[U-29]action.txt >> /check/U1~73/Action.txt
 fi


##########[U-30] Sendmail 버전 점검##########

version=$(sendmail -d0.1 < /dev/null | grep -i 'Version' | awk '{print $2}' | tr -d '.')
new=$(sendmail -d0.1 < /dev/null | grep -i 'Version' | awk '{print $2}' | awk -F. '{if($1<8 || $1=8 && $2>17 || $1=8 && $2=17 && $3<=1) print "good"}')

echo -e "\n##########[U-30] Sendmail 버전 점검##########\n[sendmail 버전]" >> /check/U1~73/log/[U-30]log.txt
sendmail -d0.1 < /dev/null | grep -i 'Version' >> /check/U1~73/log/[U-30]log.txt
echo -e "(23.04.02 기준 최신버전 : 8.17.1 버전)" >> /check/U1~73/log/[U-30]log.txt
cat /check/U1~73/log/[U-30]log.txt >> /check/U1~73/log.txt

if [[ $new == "good" ]] ; then
 echo -e "C|[U-30] Sendmail 버전이 최신버전입니다. - [양호]" >> /check/U1~73/good/[U-30]good.txt
 cat /check/U1~73/good/[U-30]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-30] Sendmail 버전이 최신버전이 아닙니다. - [취약]" >> /check/U1~73/bad/[U-30]bad.txt
 cat /check/U1~73/bad/[U-30]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-30] Sendmail 서비스 실행 여부 및 버전 점검 후, http://www.sendmail.org/ 또는 각 OS 벤더사의 보안 패치설치" >> /check/U1~73/action/[U-30]action.txt
 sed -e 's/\[U-30\] /\n\[(U-30)조치사항\]\n/g' /check/U1~73/action/[U-30]action.txt >> /check/U1~73/Action.txt
fi

##########[U-31] 스팸 메일 릴레이 제한##########

sendmail=$(ps -ef | grep 'sendmail' | grep -v 'grep')
deny=$(grep 'R$/*' /etc/mail/sendmail.cf | grep 'Relaying denied' | sed '/^#/d')
access=$(sed '/^#/d' /etc/mail/access)

echo -e "\n##########[U-31] 스팸 메일 릴레이 제한##########\n[사용중인 SMTP 서비스]\n$sendmail\n\n[릴레이 제한 옵션]\n$deny\n\n[sendmail 접근 제한]\n$access" >> /check/U1~73/log/[U-31]log.txt
cat /check/U1~73/log/[U-31]log.txt >> /check/U1~73/log.txt


if [[ -z $sendmail ]] || [[ -n $deny ]] && [[ -n $access ]]; then
 echo -e "C|[U-31] SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정 되어 있음 - [양호]" >> /check/U1~73/good/[U-31]good.txt
 cat /check/U1~73/good/[U-31]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-31] SMTP 서비스를 사용중이며, 릴레이 제한이 설정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-31]bad.txt
 cat /check/U1~73/bad/[U-31]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-31] vi 편집기로 sendmail.cf 설정파일을 열고, Relaying denied행의 맨앞의 #R$* 에서 # 제거하기\n특정 IP, domain, Email Address 및 네트워크에 대한 sendmail 접근 제한 확인(없을 시 파일 생성)\n수정했거나 생성했을 경우 DB파일 재시작\n-> #makemap hash /etc/mail/access.db < /etc/mail/access" >> /check/U1~73/action/[U-31]action.txt
 sed -e 's/\[U-31\] /\n\[(U-31)조치사항\]\n/g' /check/U1~73/action/[U-31]action.txt >> /check/U1~73/Action.txt
fi


##########[U-32] 일반 사용자의 Sendmail 실행 방지##########

sendmail=$(ps -ef | grep 'sendmail' | grep -v 'grep')
restrictqrun=$(sed '/^#/d' /etc/mail/sendmail.cf | grep -i 'PrivacyOptions' | grep 'restrictqrun')

echo -e "\n##########[U-32] 일반 사용자의 Sendmail 실행 방지##########\n[사용중인 SMTP 서비스]\n$sendmail\n\n[O PrivacyOptions 설정]\n$restrictqrun" >> /check/U1~73/log/[U-32]log.txt
cat /check/U1~73/log/[U-32]log.txt >> /check/U1~73/log.txt


if [[ -z $sendmail ]] || [[ -n $restrictqrun ]]; then
 echo -e "C|[U-32] SMTP 서비스를 사용하지 않거나 일반 사용자의 Sendmail 실행 방지가 설정되어 있습니다. - [양호]" >> /check/U1~73/good/[U-32]good.txt
 cat /check/U1~73/good/[U-32]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-32] SMTP 서비스를 사용중이며, 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않습니다. - [취약]" >> /check/U1~73/bad/[U-32]bad.txt
 cat /check/U1~73/bad/[U-32]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-32] vi 편집기로 sendmail.cf 설정파일을 열고, O PrivacyOptions= 설정 부분에 restrictqrun 옵션 추가\nSendmail 서비스 재시작" >> /check/U1~73/action/[U-32]action.txt
 sed -e 's/\[U-32\] /\n\[(U-32)조치사항\]\n/g' /check/U1~73/action/[U-32]action.txt >> /check/U1~73/Action.txt
fi


##########[U-33] DNS 보안 버전 패치##########

named=$(ps -ef | grep named | grep -v 'grep')
version=$(sendmail -d0.1 < /dev/null | grep -i 'Version' | awk '{print $2}')
new=$(named -v | tr -s '-' ' ' | awk '{print $2}' |  awk -F. '{if($1<9 || $1=9 && $2>11 || $1=9 && $2=11 && $3>=0) print "good"}')

echo -e "\n##########[U-33] DNS 보안 버전 패치##########\n[BIND 버전]" >> /check/U1~73/log/[U-33]log.txt
named -v | tr -s '-' ' ' | awk '{print $1, $2}' >> /check/U1~73/log/[U-33]log.txt
echo -e "(23.04.02 기준 최신버전 : 9.11.0 버전 이상)" >> /check/U1~73/log/[U-33]log.txt
cat /check/U1~73/log/[U-33]log.txt >> /check/U1~73/log.txt

if [[ -z $named ]] || [[ $new == "good" ]] ; then
 echo -e "C|[U-33] BIND 버전이 최신버전입니다. - [양호]" >> /check/U1~73/good/[U-33]good.txt
 cat /check/U1~73/good/[U-33]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-33] BIND 버전이 최신버전이 아닙니다. - [취약]" >> /check/U1~73/bad/[U-33]bad.txt
 cat /check/U1~73/bad/[U-33]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-33]  DNS 서비스를 사용하지 않는 경우 서비스 중지, DNS 서비스 사용 시 BIND 버전 확인 후 보안설정방법에 따라 최신 버전으로 업데이트" >> /check/U1~73/action/[U-33]action.txt
 sed -e 's/\[U-33\] /\n\[(U-33)조치사항\]\n/g' /check/U1~73/action/[U-33]action.txt >> /check/U1~73/Action.txt
fi



##########[U-34] DNS Zone Tranfer 설정##########

dns=$(ps -ef | grep -i 'named' | grep -v 'grep')
zone=$(sed '/^#/d' /etc/named.conf | grep -i 'allow-transfer')
xfrnets=$(sed '/^#/d' /etc/named.conf | grep -i 'xfrnets')

echo -e "\n##########[U-34] DNS Zone Tranfer 설정##########\n[사용중인 DNS 서비스]\n$dns\n\n[Zone Trasfer 설정]\n$zone\n\n[xfrnets 설정]\n$xfrnets" >> /check/U1~73/log/[U-34]log.txt
cat /check/U1~73/log/[U-34]log.txt >> /check/U1~73/log.txt


if [[ -z $dns ]] || [[ -n $zone ]]; then
 echo -e "C|[U-34] DNS 서비스를 사용하지 않거나 Zone Transfer를 허가된 사용자에게만 허용. - [양호]" >> /check/U1~73/good/[U-34]good.txt
 cat /check/U1~73/good/[U-34]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-34] DNS 서비스를 사용하며, Zone Transfer를 모든 사용자에게 허용. - [취약]" >> /check/U1~73/bad/[U-34]bad.txt
 cat /check/U1~73/bad/[U-34]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-34] vi 편집기로 /etc/named.conf 파일을 열고\nOptions에 allow -transfer (존 파일 전송을 허용하고자 하는 IP;); 추가\nOptions에 xfrnets 허용하고자 하는 IP 추가" >> /check/U1~73/action/[U-34]action.txt
 sed -e 's/\[U-34\] /\n\[(U-34)조치사항\]\n/g' /check/U1~73/action/[U-34]action.txt >> /check/U1~73/Action.txt
fi



##########[U-35] Apache 디렉토리 리스팅 제거##########

dir=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'options' | grep -v '#')
option=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'options indexes')

echo -e "\n##########[U-35] Apache 디렉토리 리스팅 제거##########\n[/etc/httpd/conf/httpd.conf 파일 모든 디렉토리에서 Options 지시자 설정]\n$dir" >> /check/U1~73/log/[U-35]log.txt
cat /check/U1~73/log/[U-35]log.txt >> /check/U1~73/log.txt


if [[ -z $option ]] ; then
 echo -e "C|[U-35] 디렉토리 검색 기능을 사용하지 않음 - [양호]" >> /check/U1~73/good/[U-35]good.txt
 cat /check/U1~73/good/[U-35]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-35] 디렉토리 검색 기능을 사용중 - [취약]" >> /check/U1~73/bad/[U-35]bad.txt
 cat /check/U1~73/bad/[U-35]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-35] vi 편집기를 이용하여 /etc/httpd/conf/httpd.conf 파일을 열어 모든 디렉토리의 Options 지시자에서 Indexes 옵션 제거 후 Options 지시자를 None 으로 변경 후 저장" >> /check/U1~73/action/[U-35]action.txt
 sed -e 's/\[U-35\] /\n\[(U-35)조치사항\]\n/g' /check/U1~73/action/[U-35]action.txt >> /check/U1~73/Action.txt
fi


##########[U-36] Apache 웹 프로세스 권한 제한##########

perm=$(grep -zoP 'User.*\nGroup.*' /etc/httpd/conf/httpd.conf)
user=$(grep -zoP 'User.*\nGroup.*' /etc/httpd/conf/httpd.conf | grep -i 'user' | awk '{print $2}')
group=$(grep -zoP 'User.*\nGroup.*' /etc/httpd/conf/httpd.conf | grep -i 'group' | awk '{print $2}')

echo -e "\n##########[U-36] Apache 웹 프로세스 권한 제한##########\n[Apache 데몬 구동 권한]\n$perm" >> /check/U1~73/log/[U-36]log.txt
cat /check/U1~73/log/[U-36]log.txt >> /check/U1~73/log.txt

if [[ $user != 'root' ]] && [[ $group != 'root' ]] ; then
 echo -e "C|[U-36] Apache 데몬이 root 권한으로 구동되고 있지 않음 - [양호]" >> /check/U1~73/good/[U-36]good.txt
 cat /check/U1~73/good/[U-36]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-36] Apache 데몬이 root 권한으로 구동되고 있음 - [취약]" >> /check/U1~73/bad/[U-36]bad.txt
 cat /check/U1~73/bad/[U-36]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-36] vi 편집기로 /etc/httpd/conf/httpd.conf 파일에 들어가서 User & Group 부분에 root가 아닌 별도 계정으로 변경 후 Apache 서비스 재시작" >> /check/U1~73/action/[U-36]action.txt
 sed -e 's/\[U-36\] /\n\[(U-36)조치사항\]\n/g' /check/U1~73/action/[U-36]action.txt >> /check/U1~73/Action.txt
fi



##########[U-37] Apache 상위 디렉토리 접근 금지##########

dir=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'AllowOverride' | grep -v '#')
allow=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'AllowOverride none')

echo -e "\n##########[U-37] Apache 상위 디렉토리 접근 금지##########\n[/etc/httpd/conf/httpd.conf 파일 모든 디렉토리에서의 AllowOverride 설정]\n$dir" >> /check/U1~73/log/[U-37]log.txt
cat /check/U1~73/log/[U-37]log.txt >> /check/U1~73/log.txt


if [[ -z $allow ]] ; then
 echo -e "C|[U-37] 상위 디렉토리에 이동제한이 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-37]good.txt
 cat /check/U1~73/good/[U-37]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-37] 상위 디렉토리에 이동제한이 설정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-37]bad.txt
 cat /check/U1~73/bad/[U-37]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-37] vi 편집기를 이용하여 /etc/httpd/conf/httpd.conf 파일을 열어 모든 디렉토리의 AllowOverride 지시자에서 AuthConfig 옵션 제거 후 AllowOverride 지시자를 None에서 AuthConfig 또는 All로 변경 후 저장\n사용자 인증을 설정할 디렉토리에 .htaccess 파일 생성\n사용자 인증에 사용할 아이디 및 패스워드 생성 -> htpasswd -c <인증 파일> <사용자 계정>\n변경된 설정을 적용하기 위해 Apache 데몬 재시작" >> /check/U1~73/action/[U-37]action.txt
 sed -e 's/\[U-37\] /\n\[(U-37)조치사항\]\n/g' /check/U1~73/action/[U-37]action.txt >> /check/U1~73/Action.txt
fi



##########[U-38] Apache 불필요한 파일 제거##########

man=$(ls -ld /etc/httpd/manual 2>/dev/null)
htman=$(ls -ld /etc/httpd/htdocs/manual 2>/dev/null)

echo -e "\n##########[U-38] Apache 불필요한 파일 제거##########\n[/etc/httpd 내 불필요한 메뉴얼 파일 및 디렉토리 존재 여부]\n$man\n$htman" >> /check/U1~73/log/[U-38]log.txt
cat /check/U1~73/log/[U-38]log.txt >> /check/U1~73/log.txt


if [[ -z $man ]] && [[ -z $htman ]] ; then
 echo -e "C|[U-38] 기본으로 생성되는 불필요한 파일 및 디렉토리가 제거되어 있음 - [양호]" >> /check/U1~73/good/[U-38]good.txt
 cat /check/U1~73/good/[U-38]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-38] 기본으로 생성되는 불필요한 파일 및 디렉토리가 제거되지 않음 - [취약]" >> /check/U1~73/bad/[U-38]bad.txt
 cat /check/U1~73/bad/[U-38]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-38] rm -rf 명령어로 확인된 파일 및 디렉토리 제거\nls -ld 명령어로 정상적인 제거 확인\n추가적으로 웹서비스 운영에 불필요한 파일이나 디렉토리가 있을 시 제거" >> /check/U1~73/Action.txt
 sed -e 's/\[U-38\] /\n\[(U-38)조치사항\]\n/g' /check/U1~73/action/[U-38]action.txt >> /check/U1~73/Action.txt
fi



##########[U-39] Apache 링크 사용 금지##########

dir=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'options' | grep -v '#')
option=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'options' | grep -i 'FollowSymLinks')

echo -e "\n##########[U-39] Apache 링크 사용 금지##########\n[/etc/httpd/conf/httpd.conf 파일 모든 디렉토리에서 Options 지시자 설정]\n$dir" >> /check/U1~73/log/[U-39]log.txt
cat /check/U1~73/log/[U-39]log.txt >> /check/U1~73/log.txt


if [[ -z $option ]] ; then
 echo -e "C|[U-39] 심볼릭 링크, aliases 사용이 제한되어 있음 - [양호]" >> /check/U1~73/good/[U-39]good.txt
 cat /check/U1~73/good/[U-39]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-39] 심볼릭 링크, aliases 사용이 제한되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-39]bad.txt
 cat /check/U1~73/bad/[U-39]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-39] vi 편집기를 이용하여 /etc/httpd/conf/httpd.conf 파일을 열어 모든 디렉토리의 Options 지시자에서 FollowSymLinks 옵션 제거 후 Options 지시자에 None 변경 후 저장" >> /check/U1~73/action/[U-39]action.txt
 sed -e 's/\[U-39\] /\n\[(U-39)조치사항\]\n/g' /check/U1~73/action/[U-39]action.txt >> /check/U1~73/Action.txt
fi



##########[U-40] Apache 파일 업로드 및 다운로드 제한##########

dir=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'limitrequestbody' | grep -v '#')
limit=$(grep -B 10 '</Directory>' /etc/httpd/conf/httpd.conf | grep -i 'limitrequestbody' | grep -v '#' | awk '{print $2}')

echo -e "\n##########[U-40] Apache 파일 업로드 및 다운로드 제한##########\n[/etc/httpd/conf/httpd.conf 파일 모든 디렉토리에서의 LimitRequestBody 설정]\n$dir" >> /check/U1~73/log/[U-40]log.txt
cat /check/U1~73/log/[U-40]log.txt >> /check/U1~73/log.txt


if [[ -n $limit ]]; then
 echo -e "C|[U-40] 파일 업로드 및 다운로드가 제한되어 있음 - [양호]" >> /check/U1~73/good/[U-40]good.txt
 cat /check/U1~73/good/[U-40]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-40] 파일 업로드 및 다운로드가 제한되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-40]bad.txt
 cat /check/U1~73/bad/[U-40]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-40] vi 편집기로 /etc/httpd/conf/httpd.conf 파일에 들어가서 모든 디렉토리의 LimitRequestBody 지시자에서 파일 사이즈 용량 제한 설정\n(업로드 및 다운로드 파일이 5M를 넘지 않도록 설정 권고)" >> /check/U1~73/action/[U-40]action.txt
 sed -e 's/\[U-40\] /\n\[(U-40)조치사항\]\n/g' /check/U1~73/action/[U-40]action.txt >> /check/U1~73/Action.txt
fi


##########[U-41] Apache 웹 서비스 영역의 분리##########

dir=$(grep -i 'DocumentRoot' /etc/httpd/conf/httpd.conf | grep -v '#' )
var=$(grep -i 'DocumentRoot' /etc/httpd/conf/httpd.conf | grep -v '#' | grep -i '/var/www/html')
usr1=$(grep -i 'DocumentRoot' /etc/httpd/conf/httpd.conf | grep -v '#' | grep -i '/usr/local/apache/htdocs')
usr2=$(grep -i 'DocumentRoot' /etc/httpd/conf/httpd.conf | grep -v '#' | grep -i '/usr/local/apache2/htdocs')

echo -e "\n##########[U-41] Apache 웹 서비스 영역의 분리##########\n[/etc/httpd/conf/httpd.conf 파일 디렉토리 설정]\n$dir" >> /check/U1~73/log/[U-41]log.txt
cat /check/U1~73/log/[U-41]log.txt >> /check/U1~73/log.txt

if [[ -z $var ]] && [[ -z $usr1 ]] && [[ -z $usr2 ]] ; then
 echo -e "C|[U-41] DocumnetRoot가 별도의 디렉토리로 지정되어 있음 - [양호]" >> /check/U1~73/good/[U-41]good.txt
 cat /check/U1~73/good/[U-41]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-41] DocumnetRoot가 별도의 디렉토리로 지정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-41]bad.txt
 cat /check/U1~73/bad/[U-41]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-41] vi 편집기로 /etc/httpd/conf/httpd.conf 파일에 들어가서 DocumentRoot 설정 부분에 '/usr/local/apache/htdocs', '/usr/local/apache2/htdocs', '/var/www/html' 셋 중 하나가 아닌 별도의 디렉토리로 변경" >> /check/U1~73/action/[U-41]action.txt
 sed -e 's/\[U-41\] /\n\[(U-41)조치사항\]\n/g' /check/U1~73/action/[U-41]action.txt >> /check/U1~73/Action.txt
fi


##########[U-44] root 이외의 UID가 '0' 금지##########

uid=$(awk -F: '{if ($1 != "root" && $3 == 0 ) print ($0)}' /etc/passwd)

echo -e "\n##########[U-44] root 이외의 UID가 '0' 금지##########\n[root 이외의 UID가 '0'인 계정]\n$uid" >> /check/U1~73/log/[U-44]log.txt
cat /check/U1~73/log/[U-44]log.txt >> /check/U1~73/log.txt

if [[ -z $uid ]] ; then
 echo -e "A|[U-44] root 계정과 동일한 UID를 갖는 계정이 존재하지 않음 - [양호]" >> /check/U1~73/good/[U-44]good.txt
 cat /check/U1~73/good/[U-44]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-44] root 계정과 동일한 UID를 갖는 계정이 존재 - [취약]" >> /check/U1~73/bad/[U-44]bad.txt
 cat /check/U1~73/bad/[U-44]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-44] usermod 명령으로 UID가 0인 일반 계정의 UID를 500 이상으로 수정" >> /check/U1~73/action/[U-44]action.txt
 sed -e 's/\[U-44\] /\n\[(U-44)조치사항\]\n/g' /check/U1~73/action/[U-44]action.txt >> /check/U1~73/Action.txt
fi



##########[U-45] root 계정 su 제한##########

mem=$(grep -i 'wheel' /etc/group | awk -F: '{print $4}')
perm=$(stat /usr/bin/su | sed -n '4p' | awk '{print $2}' | cut -c 2-5)
group=$(ls -al /usr/bin/su | awk '{print $4}')
pam=$(sed '/^#/d' /etc/pam.d/su | grep 'auth' | grep 'required' | grep 'pam_wheel.so' | grep 'use_uid')

echo -e "\n##########[U-45] root 계정 su 제한##########\n[wheel 그룹 내 구성원]\n$mem\n\n[wheel 그룹 권한]\n$perm\n\n[/usr/bin/su 소유 그룹]\n$group\n\n[PAM 설정]\n$pam" >> /check/U1~73/log/[U-45]log.txt
cat /check/U1~73/log/[U-45]log.txt >> /check/U1~73/log.txt

if [[ -n $mem ]] && [[ $perm = '4750' ]] && [[ $group == "wheel" ]] || [[ -n $mem ]] && [[ -n $pam ]] ; then
 echo -e "A|[U-45] su 명령어가 특정 그룹에 속한 사용자만 사용하도록 제한되어 있음 - [양호]" >> /check/U1~73/good/[U-45]good.txt
 cat /check/U1~73/good/[U-45]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-45] su 명령어가 특정 그룹에 속한 사용자만 사용하도록 제한되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-45]bad.txt
 cat /check/U1~73/bad/[U-45]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-45] [일반 사용자의 su 명령 제한]\n1. wheel groupt 생성 -> #groupadd wheel\n2. su 명령어 그룹 변경 -> #chgrp wheel /usr/bin/su\n3. su 명령어의 권한 변경 -> #chmod 4750 /usr/bin/su\n4. su 명령어 사용이 필요한 계정을 wheel 그룹에 추가 -> #usermod -G wheel <user_name>\n\n[LINUX PAM 모듈을 이용한 방법]\n1./etc/pam.d/su 파일에서 auth required pam_wheel.so use_uid 맨 앞의 주석 제거, wheel 그룹에 su 명령어를 사용할 사용자 추가 -> #usermod -G wheel <user_name>" >> /check/U1~73/action/[U-45]action.txt
 sed -e 's/\[U-45\] /\n\[(U-45)조치사항\]\n/g' /check/U1~73/action/[U-45]action.txt >> /check/U1~73/Action.txt
fi



##########[U-46] 패스워드 최소 길이 설정##########

len=$(grep -i 'pass_min_len' /etc/login.defs | sed  '/^#/d' | awk '{print $2}')

echo -e "\n##########[U-46] 패스워드 최소 길이 설정##########\n[패스워드 최소 길이]\n : $len" >> /check/U1~73/log/[U-46]log.txt
cat /check/U1~73/log/[U-46]log.txt >> /check/U1~73/log.txt

if [[ $len -ge '8' ]] ; then
 echo -e "A|[U-46] 패스워드 최소 길이가 8자 이상으로 설정되어 있음(공공기관의 경우 9자리 이상) - [양호]" >> /check/U1~73/good/[U-46]good.txt
 cat /check/U1~73/good/[U-46]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-46] 패스워드 최소 길이가 8자 미만으로 설정되어 있음(공공기관의 경우 9자리 미만) - [취약]" >> /check/U1~73/bad/[U-46]bad.txt
 cat /check/U1~73/bad/[U-46]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-46] vi 편집기로 /etc/login.des 파일에 들어가서 PASS_MIN_LEN 부분에 8(공공기관의 경우 9) 로 수정 또는 신규 삽입" >> /check/U1~73/action/[U-46]action.txt
 sed -e 's/\[U-46\] /\n\[(U-46)조치사항\]\n/g' /check/U1~73/action/[U-46]action.txt >> /check/U1~73/Action.txt
fi



##########[U-47] 패스워드 최대 사용기간 설정##########

day=$(grep -i 'pass_max_days' /etc/login.defs | sed  '/^#/d' | awk '{print $2}')

echo -e "\n##########[U-47] 패스워드 최대 사용기간 설정##########\n[패스워드 최대 사용기간]\n : $day" >> /check/U1~73/log/[U-47]log.txt
cat /check/U1~73/log/[U-47]log.txt >> /check/U1~73/log.txt

if [[ $day -le '90' ]] ; then
 echo -e "A|[U-47] 패스워드 최대 사용기간이 90일 이하로 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-47]good.txt
 cat /check/U1~73/good/[U-47]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-47] 패스워드 최대 사용기간이 90일 이하로 설정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-47]bad.txt
 cat /check/U1~73/bad/[U-47]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-47] vi 편집기로 /etc/login.des 파일에 들어가서 PASS_MAX_DAYS 부분에 90 이하로 수정 또는 신규 삽입" >> /check/U1~73/action/[U-47]action.txt
 sed -e 's/\[U-47\] /\n\[(U-47)조치사항\]\n/g' /check/U1~73/action/[U-47]action.txt >> /check/U1~73/Action.txt
fi




##########[U-48] 패스워드 최소 사용기간 설정##########

day=$(grep -i 'pass_min_days' /etc/login.defs | sed  '/^#/d' | awk '{print $2}')

echo -e "\n##########[U-48] 패스워드 최소 사용기간 설정##########\n[패스워드 최소 사용기간]\n : $day" >> /check/U1~73/log/[U-48]log.txt
cat /check/U1~73/log/[U-48]log.txt >> /check/U1~73/log.txt

if [[ -n $day ]] ; then
 echo -e "A|[U-48] 패스워드 최소 사용기간이 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-48]good.txt
 cat /check/U1~73/good/[U-48]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-48] 패스워드 최소 사용기간이 설정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-48]bad.txt
 cat /check/U1~73/bad/[U-48]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-48] vi 편집기로 /etc/login.des 파일에 들어가서 PASS_MIN_DAYS 부분에 1 이상으로 수정 또는 신규 삽입" >> /check/U1~73/action/[U-48]action.txt
 sed -e 's/\[U-48\] /\n\[(U-48)조치사항\]\n/g' /check/U1~73/action/[U-48]action.txt >> /check/U1~73/Action.txt
fi



##########[U-49] 불필요한 계정 제거##########

nouse=$(cat /etc/passwd | egrep 'lp|uucp|nuucp')
id=$(lastlog)

echo -e "\n##########[U-49] 불필요한 계정 제거##########\n[계정 이름 및 최근 로그인 정보]\n : $id" >> /check/U1~73/log/[U-49]log.txt
cat /check/U1~73/log/[U-49]log.txt >> /check/U1~73/log.txt

echo -e "A|[U-49] 불필요한 계정이 존재하는지 점검 필요 - [점검]" >> /check/U1~73/bad/[U-49]bad.txt
cat /check/U1~73/bad/[U-49]bad.txt >> /check/U1~73/inspect.txt
echo -e "[U-49] 현재 등록된 계정 현황 확인 후 불필요한 계정 삭제 -> #userdel <user_name>" >> /check/U1~73/action/[U-49]action.txt
sed -e 's/\[U-49\] /\n\[(U-49)조치사항\]\n/g' /check/U1~73/action/[U-49]action.txt >> /check/U1~73/Action.txt




##########[U-50] 관리자 그룹에 최소한의 계정 포함##########

grp=$(awk -F: '{if ($1=="root") print $4}' /etc/group)

echo -e "\n##########[U-50] 관리자 그룹에 최소한의 계정 포함##########\n[root 그룹에 등록되어 있는 계정]\n$grp" >> /check/U1~73/log/[U-50]log.txt
cat /check/U1~73/log/[U-50]log.txt >> /check/U1~73/log.txt

echo -e "A|[U-50] root 그룹에 불필요한 계정이 존재하는지 점검 필요 - [점검]" >> /check/U1~73/bad/[U-50]bad.txt
cat /check/U1~73/bad/[U-50]bad.txt >> /check/U1~73/inspect.txt
echo -e "[U-50] vi 편집기를 이용해 /etc/group 파일에 들어가 root 그룹에 등록된 불필요한 계정 삭제" >> /check/U1~73/action/[U-50]action.txt
sed -e 's/\[U-50\] /\n\[(U-50)조치사항\]\n/g' /check/U1~73/action/[U-50]action.txt >> /check/U1~73/Action.txt



##########[U-51] 계정이 존재하지 않는 GID 금지##########

omem=$(cat /etc/gshadow | awk -F: '$4 !~ /^$/ {print "GROUP:"$1, "MEMBER:"$4}')
nmem=$(cat /etc/gshadow | awk -F: '$4 ~ /^$/ {print "GROUP:"$1}')

echo -e "\n##########[U-51] 계정이 존재하지 않는 GID 금지##########\n[구성원이 존재하는 그룹]\n$omem\n\n[구성원이 존재하지 않는 그룹]\n$nmem" >> /check/U1~73/log/[U-51]log.txt
cat /check/U1~73/log/[U-51]log.txt >> /check/U1~73/log.txt

echo -e "A|[U-51] 그룹 설정 파일에 불필요한 그룹(계정이 존재하지 않고 시스템 관리나 운용에 사용되지 않는 그룹), 계정이 존재하고 시스템 관리나 운용에 사용되지 않는 그룹 등이 존재하는지 점검 필요 - [점검]" >> /check/U1~73/bad/[U-51]bad.txt
cat /check/U1~73/bad/[U-51]bad.txt >> /check/U1~73/inspect.txt

echo -e "[U-51] groupdel <group_name> 을 사용하여\n(1)구성원이 존재하지 않고 시스템 관리나 운용에 사용되지 않는 그룹, (2)구성원이 존재하지만 불필요한 그룹 삭제\nlog.txt 파일의 [구성원이 존재하지 않는 그룹]을 확인하여 그룹(1)에 해당하는 그룹을 삭제하시오.\nlog.txt 파일의 [구성원이 존재하는 그룹]을 확인하여 그룹(2)에 해당하는 그룹을 삭제하시오." >> /check/U1~73/action/[U-51]action.txt
sed -e 's/\[U-51\] /\n\[(U-51)조치사항\]\n/g' /check/U1~73/action/[U-51]action.txt >> /check/U1~73/Action.txt



##########[U-52] 동일한 UID 금지##########

UID_DUPE=$(awk -F: '{print $3}' /etc/passwd | sort | uniq -d)

echo -e "\n##########[U-52] 동일한 UID 금지##########\n[2개 이상 중복되는 UID]\n$UID_DUPE" >> /check/U1~73/log/[U-52]log.txt
cat /check/U1~73/log/[U-52]log.txt >> /check/U1~73/log.txt

if [[ -z $UID_DUPE ]] ; then
 echo -e "A|[U-52] /etc/passwd 안에 동일한 UID로 설정된 사용자 계정이 존재하지 않습니다. - [양호]" >> /check/U1~73/good/[U-52]good.txt
 cat /check/U1~73/good/[U-52]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-52] /etc/passwd 안에 동일한 UID로 설정된 사용자 계정이 존재합니다. - [취약]" >> /check/U1~73/bad/[U-52]bad.txt
 cat /check/U1~73/bad/[U-52]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-52] usermod -u 명령으로  동일한 UID로 설정된 사용자 계정의 UID를 변경한다. \n #usermod -u <변경할 UID값> <user_name>" >> /check/U1~73/action/[U-52]action.txt
 sed -e 's/\[U-52\] /\n\[(U-52)조치사항\]\n/g' /check/U1~73/action/[U-52]action.txt >> /check/U1~73/Action.txt
fi


##########[U-53] 사용자 shell 점검##########

log=$(egrep '^daemon|^bin|^sys|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher' /etc/passwd | awk -F: '{print "ID : "$1,"\tshell : "$7}')
shell=$(egrep '^daemon|^bin|^sys|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher' /etc/passwd | awk -F: '{print $1,$7}' | egrep -v "/bin/false|/sbin/nologin")

echo -e "\n##########[U-53] 사용자 shell 점검##########\n[로그인이 필요하지 않은 계정 이름 및 쉘]\n$log" >> /check/U1~73/log/[U-53]log.txt
cat /check/U1~73/log/[U-53]log.txt >> /check/U1~73/log.txt

if [[ -z $shell ]] ; then
 echo -e "A|[U-53] 로그인이 필요하지 않은 계정에 /bin/false(/sbin/nologin) 쉘이 부여되어 있습니다. - [양호]" >> /check/U1~73/good/[U-53]good.txt
 cat /check/U1~73/good/[U-53]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-53] 로그인이 필요하지 않은 계정에 /bin/false(/sbin/nologin) 쉘이 부여되어 있지 않습니다.. - [취약]" >> /check/U1~73/bad/[U-53]bad.txt
 cat /check/U1~73/bad/[U-53]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-53] vi 편집기를 이용하여 /etc/passwd 파일을 열고, 로그인 쉘 부분인 계정 맨 마지막에 /bin/false(/sbin/nologin) 부여 및 변경" >> /check/U1~73/action/[U-53]action.txt
 sed -e 's/\[U-53\] /\n\[(U-53)조치사항\]\n/g' /check/U1~73/action/[U-53]action.txt >> /check/U1~73/Action.txt
fi



##########[U-54] Session Timeout 설정##########

export=$(grep -i 'export tmout' /etc/profile | sed '/^#/d')
tmout=$(grep -i 'tmout' /etc/profile | grep -v 'export' | awk -F= '{print $2}')

echo -e "\n##########[U-54] Session Timeout 설정##########\n[Session Timeout 설정]\n$export\nSession Timeout 시간(초) : $tmout" >> /check/U1~73/log/[U-54]log.txt
cat /check/U1~73/log/[U-54]log.txt >> /check/U1~73/log.txt

if [[ -n $export ]] && [[ $tmout -le '600' ]] ; then
 echo -e "A|[U-54] Session Timeout이 600초(10분) 이하로 설정되어 있습니다. - [양호]" >> /check/U1~73/good/[U-54]good.txt
 cat /check/U1~73/good/[U-54]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "A|[U-54] Session Timeout이 600초 이하로 설정되어 있지 않습니다. - [취약]" >> /check/U1~73/bad/[U-54]bad.txt
 cat /check/U1~73/bad/[U-54]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-54] vi 편집기를 이용하여 /etc/profile파일을 열고,\nTMOUT=600\nexport TMOUT 수정 또는 추가하기" >> /check/U1~73/action/[U-54]action.txt
 sed -e 's/\[U-54\] /\n\[(U-54)조치사항\]\n/g' /check/U1~73/action/[U-54]action.txt >> /check/U1~73/Action.txt
fi



##########[U-55] hosts.lpd 파일 소유자 및 권한 설정##########

CF=/etc/hosts.lpd
PERM=$(stat /etc/hosts.lpd 2>/dev/null | sed -n '4p' | awk '{print$2}' | cut -c 3-5)
OWNER=$(ls -l /etc/hosts.lpd 2>/dev/null | awk '{print $3}')

echo -e "\n##########[U-55] hosts.lpd 파일 소유자 및 권한 설정##########\n[/etc/hosts.lpd 파일의 소유자 및 권한]\n소유자:$PERM , 권한:$OWNER\n(빈칸이면 존재하지 않음)" >> /check/U1~73/log/[U-55]log.txt
cat /check/U1~73/log/[U-55]log.txt >> /check/U1~73/log.txt

if [[ -e $CF ]];then
 if [[ $PERM == '600' ]] && [[ $OWNER == 'root' ]]; then
  echo -e "B|[U-55] hosts.lpd 파일의 소유자가 root이고, 권한이 600으로 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-55]good.txt
  cat /check/U1~73/good/[U-55]good.txt >> /check/U1~73/inspect.txt
 else
  echo -e "B|[U-55] hosts.lpd 파일의 소유자가 root가 아니거나, 권한이 600이 아닌 경우 - [취약]" >> /check/U1~73/bad/[U-55]bad.txt
  cat /check/U1~73/bad/[U-55]bad.txt >> /check/U1~73/inspect.txt
  echo -e "[U-55] chown, chmod 명령어를 사용하여 /etc/hosts.lpd 파일의 소유자 및 권한 변경 (소유자 root, 권한 600)" >> /check/U1~73/action/[U-55]action.txt
  sed -e 's/\[U-55\] /\n\[(U-55)조치사항\]\n/g' /check/U1~73/action/[U-55]action.txt >> /check/U1~73/Action.txt
 fi
else
 echo -e "B|[U-55] /etc/hosts.lpd 파일이 존재하지 않음 - [양호]" >> /check/U1~73/good/[U-55]good.txt
 cat /check/U1~73/good/[U-55]good.txt >> /check/U1~73/inspect.txt
fi



##########[U-56] NIS 서비스 비활성화##########

ypserv=$(systemctl status ypserv 2>/dev/null | grep 'Active' | awk '{ print $3 }' | sed 's/[^a-z,A-Z]//g')
yppasswdd=$(systemctl status yppasswdd 2>/dev/null | grep 'Active' | awk '{ print $3 }' | sed 's/[^a-z,A-Z]//g')
ypxfrd=$(systemctl status ypxfrd 2>/dev/null | grep 'Active' | awk '{ print $3 }' | sed 's/[^a-z,A-Z]//g')
ypbind=$(systemctl status ypbind 2>/dev/null | grep 'Active' | awk '{ print $3 }' | sed 's/[^a-z,A-Z]//g')
rpcbind=$(systemctl status rpcbind 2>/dev/null | grep 'Active' | awk '{ print $3 }' | sed 's/[^a-z,A-Z]//g')

echo -e "\n##########[U-56] NIS 서비스 비활성화##########\n[NIS 데몬 활성화 여부]\nypserv:$ypserv\nyppasswd:$yppasswdd\nypxfrd:$ypxfrd\nypbind:$ypbind\nrpcbind:$rpcbind" >> /check/U1~73/log/[U-56]log.txt
cat /check/U1~73/log/[U-56]log.txt >> /check/U1~73/log.txt


if [[ $ypserv =~ 'run' ]] || [[ $yppasswdd =~ 'run' ]] || [[ $ypxfrd =~ 'run' ]] || [[ $ypbind =~ 'run' ]] || [[ $rpcbind =~ 'run' ]]; then
 echo -e "B|[U-56] 불필요한 NIS 서비스가 비활성화 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-56]bad.txt
 cat /check/U1~73/bad/[U-56]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-56] 1. kill -9 [PID] 명령어를 사용하여 NIS서비스 데몬 중지\n2. rm 명령어를 이용해 시동 스크립트 삭제 또는 mv 명령어를 이용해 이름 변경 " >> /check/U1~73/action/[U-56]action.txt
 sed -e 's/\[U-56\] /\n\[(U-56)조치사항\]\n/g' /check/U1~73/action/[U-56]action.txt >> /check/U1~73/Action.txt
else
 echo -e "B|[U-56] 불필요한 NIS 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-56]good.txt
 cat /check/U1~73/good/[U-56]good.txt >> /check/U1~73/inspect.txt
fi


##########[U-57] UMASK 설정 관리##########

umask1=$(egrep 'umask *' /etc/profile | sed '/#/d' | sed '/export/d' | sed -n '1p' | awk '{print $2}')
umask2=$(egrep 'umask *' /etc/profile | sed '/#/d' | sed '/export/d' | sed -n '2p' | awk '{print $2}')

echo -e "\n##########[U-57] UMASK 설정 관리##########\n[UMASK 값]\n일반유저\t$umask1\nroot\t$umask2" >> /check/U1~73/log/[U-57]log.txt
cat /check/U1~73/log/[U-57]log.txt >> /check/U1~73/log.txt


if [[ $umask1 -ge '022' ]] && [[ $umask2 -ge '022' ]] ; then
 echo -e "B|[U-57] UMASK 값이 022 이상으로 설정 되어 있습니다. - [양호]" >> /check/U1~73/good/[U-57]good.txt
 cat /check/U1~73/good/[U-57]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "B|[U-57] UMASK 값이 022 이상으로 설정되어 있지 않습니다. - [취약]" >> /check/U1~73/bad/[U-57]bad.txt
 cat /check/U1~73/bad/[U-57]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-57] vi 편집기를 이용하여 /etc/profile 파일을 열고, umask 022\n export umask 로 수정 또는 신규 삽입" >> /check/U1~73/action/[U-57]action.txt
 sed -e 's/\[U-57\] /\n\[(U-57)조치사항\]\n/g' /check/U1~73/action/[U-57]action.txt >> /check/U1~73/Action.txt
fi



##########[U-58] 홈 디렉토리 소유자 및 권한 설정##########

cat /etc/passwd | awk -F: '{print $1}' > name.txt		# /etc/passwd에서 계정 출력해서 name.txt에 저장
cat /etc/passwd | awk -F: '{print $6}' > home.txt		# /etc/passwd에서 계정의 홈 디렉토리 출력해서 home.txt에 저장
cat /etc/passwd | awk -F: '{print $6}' | while read a; do stat --printf="%U\n" $a; done > owner1.txt 2>&1		#/etc/passwd에서 계정의 홈 디렉토리 가져와서 while문으로 해당 홈 디렉토리의 소유자들 출력해서 owner1.txt에 저장
cat /etc/passwd | awk -F: '{print $6}' | while read a; do stat -c "%A" $a | cut -c 8-10; done > perm1.txt 2>&1		#/etc/passwd에서 계정의 홈 디렉토리 가져와서 while문으로 해당 홈 디렉토리의 others 권한 출력해서 perm1.txt에 저장
cat owner1.txt | sed '/stat/s/.*/X/g' > owner2.txt		#owner1.txt에서 해당 디렉토리가 존재하지 않습니다 오류문들 X로 치환하여 owner2.txt로 저장
cat perm1.txt | sed '/stat/s/.*/X/g' > perm2.txt			#perm2.txt에서 해당 디렉토리가 존재하지 않습니다 오류문들 X로 치환하여 perm2.txt로 저장
paste -d ':' name.txt home.txt owner2.txt perm2.txt > all.txt		# ":"를 구분자로 하여 name.txt, home.txt, owner2.txt, perm2.txt 4개의 파일을 첫째 줄은 첫째 줄끼리, 둘째 줄을 둘째 줄끼리 등등등 하여 합치기
all=$(cat all.txt)
id=$(awk -F: '{print $1}' all.txt)		# 계정 이름만 id에 변수 저장
owner=$(awk -F: '{print $3}' all.txt)		# 홈 디렉토리의 소유자만 owner에 변수 저장
o_perm=$(awk -F: '{print $4}' all.txt)	# 홈 디렉토리의 others 권한만 o_perm에 변수 저장

echo -e "\n##########[U-58] 홈 디렉토리 소유자 및 권한 설정##########\n[계정 이름:홈 디렉토리:홈 디렉토리 소유자:홈 디렉토리 others 권한]\n$all" >> /check/U1~73/log/[U-58]log.txt
cat /check/U1~73/log/[U-58]log.txt >> /check/U1~73/log.txt


if [[ "$id" != "$owner" ]] || [[ $o_perm =~ "w" ]] ; then
 echo -e "B|[U-58] 홈 디렉토리 소유자가 해당 계정이고, 타 사용자 쓰기 권한이 제거되어 있지 않음. - [취약]" >> /check/U1~73/bad/[U-58]bad.txt
 cat /check/U1~73/bad/[U-58]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-58] chown <user_name> <user_home_directory> 로 소유자 변경, chmod o-w <user_home_directory> 로 권한 변경" >> /check/U1~73/action/[U-58]action.txt
 sed -e 's/\[U-58\] /\n\[(U-58)조치사항\]\n/g' /check/U1~73/action/[U-58]action.txt >> /check/U1~73/Action.txt
else
 echo -e "B|[U-58] 홈 디렉토리 소유자가 해당 계정이고, 타 사용자 쓰기 권한이 제거되어 있음. - [양호]" >> /check/U1~73/good/[U-58]good.txt
 cat /check/U1~73/good/[U-58]good.txt >> /check/U1~73/inspect.txt
fi

rm -rf name.txt home.txt owner1.txt owner2.txt perm1.txt perm2.txt	all.txt# 다 쓴 텍스트파일들 제거




##########[U-59] 홈 디렉토리로 지정한 디렉토리의 존재 관리##########

no_home=$(awk -F: '{if ($6=="/") print ($0)}' /etc/passwd)

echo -e "\n##########[U-59] 홈 디렉토리로 지정한 디렉토리의 존재 관리##########\n[홈 디렉토리가 존재하지 않는 계정]\n$no_home" >> /check/U1~73/log/[U-59]log.txt
cat /check/U1~73/log/[U-59]log.txt >> /check/U1~73/log.txt


if [[ -z $no_home ]]; then
 echo -e "B|[U-59] 홈 디렉토리가 존재하지 않는 계정이 발견되지 않음 - [양호]" >> /check/U1~73/good/[U-59]good.txt
 cat /check/U1~73/good/[U-59]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "B|[U-59] 홈 디렉토리가 존재하지 않는 계정이 발견됨 - [취약]" >> /check/U1~73/bad/[U-59]bad.txt
 cat /check/U1~73/bad/[U-59]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-59] 홈 디렉토리가 없는 사용자 계정 삭제 #userdel <user_name>, vi 편집기를 이용해 /etc/passwd에서 홈 디렉토리가 없는 사용자 계정에 홈 디렉토리 지정" >> /check/U1~73/action/[U-59]action.txt
 sed -e 's/\[U-59\] /\n\[(U-59)조치사항\]\n/g' /check/U1~73/action/[U-59]action.txt >> /check/U1~73/Action.txt
fi



##########[U-60] ssh 원격접속 허용##########

file=$(find / -type f -name ".*" 2>/dev/null)
dir=$(find / -type d -name ".*" 2>/dev/null)

echo -e "\n##########[U-60] ssh 원격접속 허용##########\n[숨겨진 파일]\n$file\n\n[숨겨진 디렉토리]\n$dir" >> /check/U1~73/log/[U-60]log.txt
cat /check/U1~73/log/[U-60]log.txt >> /check/U1~73/log.txt


if [[ -n $file ]] || [[ -n $dir ]]; then
 echo -e "B|[U-60] 불필요하거나 의심스러운 숨겨진 파일 및 디렉토리가 존재합니다. - [취약]" >> /check/U1~73/bad/[U-60]bad.txt
 cat /check/U1~73/bad/[U-60]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-60] log.txt파일의 U-60 항목을 확인하여 숨겨진 파일 및 디렉토리 중 불필요하거나 의심스러운 파일 및 디렉토리가 존재하는지 확인 및 삭제" >> /check/U1~73/action/[U-60]action.txt
 sed -e 's/\[U-60\] /\n\[조치사항\]\n/g' /check/U1~73/action/[U-60]action.txt >> /check/U1~73/Action.txt

else
 echo -e "B|[U-60] 불필요하거나 의심스러운 숨겨진 파일 및 디렉토리가 존재하지 않습니다. - [양호]" >> /check/U1~73/good/[U-60]good.txt
 cat /check/U1~73/good/[U-60]good.txt >> /check/U1~73/inspect.txt
fi



##########[U-61] ssh 원격접속 허용##########

ssh=$(systemctl status sshd | grep 'Active' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')

echo -e "\n##########[U-61] ssh 원격접속 허용##########\n[ssh 활성화 여부] : $ssh" >> /check/U1~73/log/[U-61]log.txt
cat /check/U1~73/log/[U-61]log.txt >> /check/U1~73/log.txt


if [[ $ssh =~ "dead" ]]; then
 echo -e "C|[U-61] 원격 접속 시 SSH 프로토콜 사용하지 않음 - [취약]" >> /check/U1~73/bad/[U-61]bad.txt
 cat /check/U1~73/bad/[U-61]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-61] #service start sshd 명령어로 ssh 사용" >> /check/U1~73/action/[U-61]action.txt
 sed -e 's/\[U-61\] /\n\[(U-61)조치사항\]\n/g' /check/U1~73/action/[U-61]action.txt >> /check/U1~73/Action.txt
else
 echo -e "C|[U-61] 원격 접속 시 SSH 프로토콜 사용 - [양호]" >> /check/U1~73/good/[U-61]good.txt
 cat /check/U1~73/good/[U-61]good.txt >> /check/U1~73/inspect.txt
fi



##########[U-62] ftp 서비스 확인##########

ftp=$(ps -ef | egrep -i "ftp|vsftpd|proftpd" | grep -v "grep")

echo -e "\n##########[U-62] ftp 서비스 확인##########\n[활성화 되어 있는 ftp 및 vsftp, proftp 서비스 데몬] : $ftp" >> /check/U1~73/log/[U-62]log.txt
cat /check/U1~73/log/[U-62]log.txt >> /check/U1~73/log.txt


if [[ -n $ftp ]]; then
 echo -e "C|[U-62] FTP 서비스가 활성화 되어 있음 - [취약]" >> /check/U1~73/bad/[U-62]bad.txt
 cat /check/U1~73/bad/[U-62]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-62] service vsftpd(proftp) stop 또는 kill -9 [PID] 명령어로 vsftpd 또는 ProFTP 서비스 중지" >> /check/U1~73/action/[U-62]action.txt
 sed -e 's/\[U-62\] /\n\[(U-62)조치사항\]\n/g' /check/U1~73/action/[U-62]action.txt >> /check/U1~73/Action.txt
else
 echo -e "C|[U-62] FTP 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-62]good.txt
 cat /check/U1~73/good/[U-62]good.txt >> /check/U1~73/inspect.txt
fi




##########[U-63] ftp 계정 shell 제한##########

ftp1=$(awk -F: '{if($1=="ftp")print$0}' /etc/passwd)
ftp2=$(awk -F: '{if($1=="ftp")print$0}' /etc/passwd | sed -n '/\/bin\/false/p')

echo -e "\n##########[U-63] ftp 계정 shell 제한##########\n[ftp 계정 정보]\n$ftp1" >> /check/U1~73/log/[U-63]log.txt
cat /check/U1~73/log/[U-63]log.txt >> /check/U1~73/log.txt


if [[ -z $ftp2 ]]; then
 echo -e "C|[U-63] ftp 계정에 /bin/false 쉘이 부여되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-63]bad.txt
 cat /check/U1~73/bad/[U-63]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-63] vi 편집기를 이용하여 /etc/passwd를 열고 ftp 계정의 맨 마지막 쉘 부분에 /bin/false 부여 및 변경, 또는 usermod -s /bin/false [계정 ID] 로 변경" >> /check/U1~73/action/[U-63]action.txt
 sed -e 's/\[U-63\] /\n\[(U-63)조치사항\]\n/g' /check/U1~73/action/[U-63]action.txt >> /check/U1~73/Action.txt
else
 echo -e "C|[U-63] ftp 계정에 /bin/false 쉘이 부여되어 있음 - [양호]" >> /check/U1~73/good/[U-63]good.txt
 cat /check/U1~73/good/[U-63]good.txt >> /check/U1~73/inspect.txt
fi



##########[U-64] ftpusers 파일 소유자 및 권한 설정##########

log=$(find / -type f -name *user* 2>/dev/null | egrep "\/etc\/ftp|\/etc\/ftpd|\/etc\/vsftpd" | while read a; do echo "[$a 소유자 및 권한]"; stat --printf="%U\n" $a; stat $a | sed -n '4p' | awk '{print$2}' | cut -c 3-5; done)
owner=$(find / -type f -name *user* 2>/dev/null | egrep "\/etc\/ftp|\/etc\/ftpd|\/etc\/vsftpd" | while read a; do stat --printf="%U\n" $a; stat $a | sed -n '4p' | awk '{print$2}' | cut -c 3-5; done | sed -n '1~2p' | grep -v 'root')
perm=$(find / -type f -name *user* 2>/dev/null | egrep "\/etc\/ftp|\/etc\/ftpd|\/etc\/vsftpd" | while read a; do stat --printf="%U\n" $a; stat $a | sed -n '4p' | awk '{print$2}' | cut -c 3-5; done | sed -n '2~2p' | awk '{if($NR<=640)print"good"; else print "bad"}' | grep 'bad')

echo -e "\n##########[U-64] ftpusers 파일 소유자 및 권한 설정##########\n$log" >> /check/U1~73/log/[U-64]log.txt
cat /check/U1~73/log/[U-64]log.txt >> /check/U1~73/log.txt


if [[ -z $owner ]] && [[ -z $perm ]] ; then
 echo -e "C|[U-64] ftpusers 파일의 소유자가 root이고, 권한이 640 이하로 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-64]good.txt
 cat /check/U1~73/good/[U-64]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-64] ftpusers 파일의 소유자가 root이고, 권한이 640 이하로 설정되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-64]bad.txt
 cat /check/U1~73/bad/[U-64]bad.txt >> /check/U1~73/inspect.txt

 echo -e "[U-64] chmown root <file_name>, chmod 640 <file_name> 으로 소유자 및 권한 변경\n\n vsftp를 사용할 때\n1. userlist_enable=YES인 경우 :  vsftpd.ftpusers, vsftpd.user_list 또는 ftpusers, user_list 파일의 소유자 및 권한 확인 후 변경\n2. userlist_enable=NO 또는 옵션 설정이 없는 경우 : vsftpd.ftpusers 또는 ftpusers 파일의 소유자 및 권한 확인 후 변경" >> /check/U1~73/action/[U-64]action.txt
 sed -e 's/\[U-64\] /\n\[(U-64)조치사항\]\n/g' /check/U1~73/action/[U-64]action.txt >> /check/U1~73/Action.txt
fi



##########[U-65] ftpusers 파일 설정##########

vsftp=$(systemctl status vsftpd | sed -n '3p' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')
ftpusers=$(cat /etc/vsftpd/ftpusers | grep -v '#' | grep 'root')

echo -e "\n##########[U-65] ftpusers 파일 설정##########\n[vsftp 활성화 여부] : $vsftp\n\n[ftpusers에서 root 검색] : $ftpusers" >> /check/U1~73/log/[U-65]log.txt
cat /check/U1~73/log/[U-65]log.txt >> /check/U1~73/log.txt


if [[ $vsftp == 'dead' ]] || [[ -n $ftpusers ]] ; then
 echo -e "C|[U-65] FTP 서비스가 비비활성화 되어 있거나, 활성화 시 root 계정 접속이 차단되어 있음 - [양호]" >> /check/U1~73/good/[U-65]good.txt
 cat /check/U1~73/good/[U-65]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-65] FTP 서비스가 활성화 되어 있고, root 계정 접속이 허용되어 있음 - [취약]" >> /check/U1~73/bad/[U-65]bad.txt
 cat /check/U1~73/bad/[U-65]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-65] vi 편집기를 이용하여 /etc/vsftp/ftpusers 파일을 열고\nroot 계정 추가 또는 주석 제거\n이후 vsftp 서비스 재시작" >> /check/U1~73/action/[U-65]action.txt
sed -e 's/\[U-65\] /\n\[(U-65)조치사항\]\n/g' /check/U1~73/action/[U-65]action.txt >> /check/U1~73/Action.txt
fi





##########[U-66] ftpusers 파일 설정##########

CF1=/etc/at.allow
CF2=/etc/at.deny
OWNER1=$(stat --printf="%U\n" /etc/at.allow 2>/dev/null)
OWNER2=$(stat --printf="%U\n" /etc/at.deny 2>/dev/null)
PERM1=$(stat --printf="%a\n" /etc/at.allow 2>/dev/null)
PERM2=$(stat --printf="%a\n" /etc/at.deny 2>/dev/null)

echo -e "\n##########[U-66] ftpusers 파일 설정##########\n[파일의 소유자 및 권한]\n/etc/at.allow 파일의 소유자 : $OWNER1 권한 : $PERM1 \n/etc/at.deny 파일의 소유자 : $OWNER2 권한 : $PERM2" >> /check/U1~73/log/[U-66]log.txt
cat /check/U1~73/log/[U-66]log.txt >> /check/U1~73/log.txt

if [[ -f $CF1 ]] ; then
 if [[ $OWNER1 = 'root' ]] && [[ $PERM1 -le 640 ]]; then
  echo -e "C|[U-66] at.allow 파일의 소유자가 root이고, 권한이 640 이하입니다. - [양호]" >> /check/U1~73/good/[U-66]good.txt
  cat /check/U1~73/good/[U-66]good.txt>> /check/U1~73/inspect.txt
 else
  echo -e "C|[U-66] at.allow 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-66]bad.txt
  cat /check/U1~73/bad/[U-66]bad.txt>> /check/U1~73/inspect.txt
  echo -e "[U-66] /etc/at.allow 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/at.allow\n파일 권한 변경 -> #chmod 640 /etc/at.allow" >> /check/U1~73/action/[U-66]action.txt
  sed -e 's/\[U-66\] /\n\[(U-66)조치사항\]\n/g' /check/U1~73/action/[U-66]action.txt>> /check/U1~73/Action.txt
 fi
else
 echo -e "C|[U-66] at.allow 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-66]bad.txt
 cat /check/U1~73/bad/[U-66]bad.txt>> /check/U1~73/inspect.txt
 echo -e "[U-66] at.allow 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-66]action.txt
 sed -e 's/\[U-66\] /\n\[(U-66)조치사항\]\n/g' /check/U1~73/action/[U-66]action.txt>> /check/U1~73/Action.txt
fi


if [[ -f $CF2 ]] ; then
 if [[ $OWNER2 = 'root' ]] && [[ $PERM2 -le 640 ]]; then
  echo -e "C|[U-66] at.deny 파일의 소유자가 root이고, 권한이 640 이하입니다. - [양호]" >> /check/U1~73/good/[U-66]good.txt
  cat /check/U1~73/good/[U-66]good.txt | tail -1 >> /check/U1~73/inspect.txt
 else
  echo -e "C|[U-66] at.deny 파일의 소유자가 root가 아니거나, 권한이 640 이하가 아닙니다. - [취약]" >> /check/U1~73/bad/[U-66]bad.txt
  cat /check/U1~73/bad/[U-66]bad.txt | tail -1 >> /check/U1~73/inspect.txt
   echo -e "[U-66] /etc/at.deny 파일의 소유자 및 권한 변경\n파일 소유자 변경 -> #chown root /etc/at.deny\n파일 권한 변경 -> #chmod 640 /etc/at.deny" >> /check/U1~73/action/[U-66]action.txt
  sed -e 's/\[U-66\] /\n\[(U-66)조치사항\]\n/g' /check/U1~73/action/[U-66]action.txt | tail -1 >> /check/U1~73/Action.txt
 fi
else
 echo -e "C|[U-66] at.deny 파일이 존재하지 않습니다. - [점검]" >> /check/U1~73/bad/[U-66]bad.txt
 cat /check/U1~73/bad/[U-66]bad.txt | tail -1 >> /check/U1~73/inspect.txt
 echo -e "[U-66] at.deny 파일이 존재하지 않으니 점검 필요" >> /check/U1~73/action/[U-66]action.txt
 sed -e 's/\[U-66\] /\n\[(U-66)조치사항\]\n/g' /check/U1~73/action/[U-66]action.txt | tail -1 >> /check/U1~73/Action.txt
fi



##########[U-67] SNMP 서비스 구동 점검##########

snmp=$(systemctl status snmpd | sed -n '3p' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')

echo -e "\n##########[U-67] SNMP 서비스 구동 점검##########\n[SNMP 활성화 여부] : $snmp" >> /check/U1~73/log/[U-67]log.txt
cat /check/U1~73/log/[U-67]log.txt >> /check/U1~73/log.txt


if [[ $snmp == 'dead' ]] ; then
 echo -e "C|[U-67] SNMP 서비스가 비활성화 되어 있음 - [양호]" >> /check/U1~73/good/[U-67]good.txt
 cat /check/U1~73/good/[U-67]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-67] SNMP 서비스가 활성화 되어 있있음 - [취약]" >> /check/U1~73/bad/[U-67]bad.txt
 cat /check/U1~73/bad/[U-67]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-67] service snmpd stop 명령어로 snmpd 서비스 중지" >> /check/U1~73/action/[U-67]action.txt
sed -e 's/\[U-67\] /\n\[(U-67)조치사항\]\n/g' /check/U1~73/action/[U-67]action.txt >> /check/U1~73/Action.txt
fi


##########[U-68] SNMP 서비스 Community String의 복잡성 설정##########

snmp=$(grep 'com2sec' /etc/snmp/snmpd.conf | sed '/#/d' | grep -i 'notconfiguser' | grep 'default' | egrep -i 'public|private')
string=$(grep 'com2sec' /etc/snmp/snmpd.conf | sed '/#/d' | grep -i 'notconfiguser' | grep 'default' | egrep -i 'public|private' | awk '{print $4}')

echo -e "\n##########[U-68] SNMP 서비스 Community String의 복잡성 설정##########\n[SNMP Community String 설정]\n$snmp" >> /check/U1~73/log/[U-68]log.txt
cat /check/U1~73/log/[U-68]log.txt >> /check/U1~73/log.txt


if [[ $string != 'public' ]] && [[ $string != 'private' ]] ; then
 echo -e "C|[U-68] SNMP 서비스 Community String 이름이 public, private로 설정되어 있지 않습니다. - [양호]" >> /check/U1~73/good/[U-68]good.txt
 cat /check/U1~73/good/[U-68]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-68] SNMP 서비스 Community String 이름이 public, private로 설정되어 있습니다. - [취약]" >> /check/U1~73/bad/[U-68]bad.txt
 cat /check/U1~73/bad/[U-68]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-68] vi 편집기를 이용하여 SNMP 설정파일을 열어 Community String 값을 public 또는 private에서 추측하기 어려운 값으로 변경" >> /check/U1~73/action/[U-68]action.txt
sed -e 's/\[U-68\] /\n\[(U-68)조치사항\]\n/g' /check/U1~73/action/[U-68]action.txt >> /check/U1~73/Action.txt
fi




##########[U-69] 로그온 시 경고 메세지 제공##########

server=$(cat /etc/motd | sed '/^#/d')
telnet=$(cat /etc/issue.net | sed '/^#/d')
ftp=$(grep -i 'banner' /etc/vsftpd/vsftpd.conf | tr -s '\n' ' ' | grep -v '#' | awk -F= '{print $2}')
smtp=$(grep -i 'greeting' /etc/mail/sendmail.cf | sed -e '/^#/d' | awk -F= '{print $2}')

echo -e "\n##########[U-69] 로그온 시 경고 메세지 제공##########\n[서버 로그온 메시지]\n$server\n\n[Telnet 로그온 메세지]\n$telnet\n\n[FTP 로그온 메세지]\n$ftp2\n\n[SMTP 로그온 메세지]\n$smtp" >> /check/U1~73/log/[U-69]log.txt
cat /check/U1~73/log/[U-69]log.txt >> /check/U1~73/log.txt


if [[ -n $server ]] && [[ -n $telnet ]] && [[ -n $ftp ]] && [[ -n $smtp ]]; then
 echo -e "C|[U-69] 서버 및 Telnet, FTP, SMTP에 로그온 메세지가 설정 되어 있음 - [양호]" >> /check/U1~73/good/[U-69]good.txt
 cat /check/U1~73/good/[U-69]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-69] 서버 및 Telnet, FTP, SMTP에 로그온 메세지가 설정 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-69]bad.txt
 cat /check/U1~73/bad/[U-69]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-69] 로그파일을 확인하여 경고메세지 및 배너가 설정되지 않은 파일 수정 후 inetd 데몬 재시작 " >> /check/U1~73/action/[U-69]action.txt
 sed -e 's/\[U-69\] /\n\[(U-69)조치사항\]\n/g' /check/U1~73/action/[U-69]action.txt >> /check/U1~73/Action.txt
fi




##########[U-70] NFS 설정파일 접근권한##########

CF=/etc/exports
PERM=$(stat $CF | sed -n '4p' | awk '{print$2}' | cut -c 3-5)
OWNER=$(ls -l $CF | awk '{print $3}')

echo -e "\n##########[U-70] NFS 설정파일 접근권한##########\n[파일의 소유자 및 권한]\n/etc/exports 파일의 소유자 : $OWNER 권한 : $PERM" >> /check/U1~73/log/[U-70]log.txt
cat /check/U1~73/log/[U-70]log.txt >> /check/U1~73/log.txt


if [[ $PERM -le 644 ]] && [[ $OWNER == 'root' ]]; then
 echo -e "C|[U-70] NFS 접근제어 설정파일의 소유자가 root이고, 권한이 644이하로 설정되어 있음 - [양호]" >> /check/U1~73/good/[U-70]good.txt
 cat /check/U1~73/good/[U-70]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-70] NFS 접근제어 설정파일의 소유자가 root가 아니거나, 권한이 644이하가 아닌 경우 - [취약]" >> /check/U1~73/bad/[U-70]bad.txt
 cat /check/U1~73/bad/[U-70]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-70] /etc/exports 파일의 소유자 및 권한 변경 (소유자 root, 권한 644)" >> /check/U1~73/action/[U-70]action.txt
 sed -e 's/\[U-70\] /\n\[(U-70)조치사항\]\n/g' /check/U1~73/action/[U-70]action.txt >> /check/U1~73/Action.txt
fi


##########[U-71] expn, vrfy 명령어 제한##########

SMTP_ACTIVE=$(systemctl status sendmail | sed -n '3p' | awk '{print $3}' | sed 's/[^a-z,A-Z]//g')
option=$(grep -i 'o privacyoptions' /etc/mail/sendmail.cf | awk -F= '{print $2}')


echo -e "\n##########[U-71] expn, vrfy 명령어 제한##########\n[SMTP 활성화 여부] : $SMTP_ACTIVE\n[O PrivacyOptions 설정]\n$option" >> /check/U1~73/log/[U-71]log.txt
cat /check/U1~73/log/[U-71]log.txt >> /check/U1~73/log.txt


if [[ $SMTP_ACTIVE =~ 'dead' ]] || [[ $option =~ 'noexpn' ]] && [[ $option =~ 'novrfy' ]] ; then
    echo -e "C|[U-71] SMTP 서비스를 사용하지 않거나 O PrivacyOptions에 noexpn, novrfy 옵션이 추가되어 있습니다. - [양호]" >> /check/U1~73/good/[U-71]good.txt
 cat /check/U1~73/good/[U-71]good.txt >> /check/U1~73/inspect.txt
else
    echo -e "C|[U-71] SMTP 서비스를 사용하고 있고, O PrivacyOptions에 noexpn 또는 novrfy 옵션이 추가되어 있지 않습니다. - [취약]" >> /check/U1~73/bad/[U-71]bad.txt
 cat /check/U1~73/bad/[U-71]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-71] kill -9 [PID] 명령어로 SMTP 서비스 중지\n또는 /etc/mail/sendmail.f 파일에 noexpn, novrfy 옵션 추가" >> /check/U1~73/action/[U-71]action.txt
 sed -e 's/\[U-71\] /\n\[(U-71)조치사항\]\n/g' /check/U1~73/action/[U-71]action.txt >> /check/U1~73/Action.txt
fi





##########[U-72] Apache 웹 서비스 정보 숨김##########

TOK=$(grep -i "ServerTokens" /etc/httpd/conf/httpd.conf | awk '{print $2}')
prod=$(grep -i "ServerTokens" /etc/httpd/conf/httpd.conf | tr [A-Z] [a-z] | awk '{if($2 != "prod")print "bad"; else print "good"}')
SIG=$(grep -i "ServerSignature" /etc/httpd/conf/httpd.conf | awk '{print $2}')
off=$(grep -i "ServerSignature" /etc/httpd/conf/httpd.conf | tr [A-Z] [a-z] | awk '{if($2 != "off")print "bad"; else print "good"}')



echo -e "\n##########[U-72] Apache 웹 서비스 정보 숨김##########\n[ServerTokens 옵션 설정] : $TOK \n[ServerSignature 옵션 설정] : $SIG" >> /check/U1~73/log/[U-72]log.txt
cat /check/U1~73/log/[U-72]log.txt >> /check/U1~73/log.txt


if [[ $prod != "bad" ]] && [[ $off != "bad" ]]; then
 echo -e "C|[U-72] ServerTokens Prod, ServerSignature Off로 설정 되어 있음 - [양호]" >> /check/U1~73/good/[U-72]good.txt
 cat /check/U1~73/good/[U-72]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "C|[U-72] ServerTokens Prod, ServerSignature Off로 설정 되어 있지 않음 - [취약]" >> /check/U1~73/bad/[U-72]bad.txt
 cat /check/U1~73/bad/[U-72]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-72] vi 편집기를 이용하여 /etc/httpd/conf/httpd.conf 파일을 연 후 설정된 모든 디렉토리의 ServerTokens 지시자에서 Prod 옵션 설정 및 ServerSignature 지시자에서 Off 옵션 설정 (없으면 신규 삽입)" >> /check/U1~73/action/[U-72]action.txt
 sed -e 's/\[U-72\] /\n\[(U-72)조치사항\]\n/g' /check/U1~73/action/[U-72]action.txt >> /check/U1~73/Action.txt
fi





##########[U-73] 정책에 따른 시스템 로깅 설정##########

CF=/etc/rsyslog.conf
MESS=$(grep "/var/log/messages" /etc/rsyslog.conf)
mess=$(grep "/var/log/messages" /etc/rsyslog.conf | grep "*.info;mail.none;authpriv.none;cron.none")
SEC=$(grep "/var/log/secure" /etc/rsyslog.conf)
sec=$(grep "/var/log/secure" /etc/rsyslog.conf | grep "authpriv.*")
MAIL=$(grep "/var/log/maillog" /etc/rsyslog.conf)
mail=$(grep "/var/log/maillog" /etc/rsyslog.conf | grep "mail.*")
CRON=$(grep "/var/log/cron" /etc/rsyslog.conf)
cron=$(grep "/var/log/cron" /etc/rsyslog.conf | grep "cron.*")
CON=$(grep "/dev/console" /etc/rsyslog.conf)
con=$(grep "/dev/console" /etc/rsyslog.conf | grep "*.alert")
EMG=$(grep "*.emerg" /etc/rsyslog.conf)
emg=$(grep "*.emerg" /etc/rsyslog.conf | awk '{if ($2=="*")print $0;}')


echo -e "\n##########[U-73] 정책에 따른 시스템 로깅 설정##########\n[rsyslog.conf 시스템 로깅 설정]\n$MESS\n$SEC\n$MAIL\n$CRON\n$CON\n$EMG" >> /check/U1~73/log/[U-73]log.txt
cat /check/U1~73/log/[U-73]log.txt >> /check/U1~73/log.txt


if [[ -n $sec ]] && [[ -n $mail ]] && [[ -n $cron ]] && [[ -n $con ]] && [[ -n $emg ]]; then
 echo -e "E|[U-73] 로그 기록 정책이 정책에 따라 설정되어 수립되어 있으며 보안정책에 따라 로그를 남기고 있음 - [양호]" >> /check/U1~73/good/[U-73]good.txt
 cat /check/U1~73/good/[U-73]good.txt >> /check/U1~73/inspect.txt
else
 echo -e "E|[U-73] 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않으며 보안정책에 따라 로그를 남기고 있지 않음 - [취약]" >> /check/U1~73/bad/[U-73]bad.txt
 cat /check/U1~73/bad/[U-73]bad.txt >> /check/U1~73/inspect.txt
 echo -e "[U-73] 로그 기록 정책을 수립하고, 정책에 따라 vi 편집기를 이용해 rsyslog.conf 파일을 설정 \n설정 후  RSYSLOG 데몬 재시작" >> /check/U1~73/action/[U-73]action.txt
 sed -e 's/\[U-73\] /\n\[(U-73)조치사항\]\n/g' /check/U1~73/action/[U-73]action.txt >> /check/U1~73/Action.txt
fi
