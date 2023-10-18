#!/bin/bash

mkdir -p S1~73 S1~73/log S1~73/action S1~73/bad S1~73/good

##########[S-01]root 계정 원격 접속 제한##########

ssh=$(cat /etc/ssh/sshd_config | grep -i "PermitRootLogin")
telnet=$(cat /etc/default/login | grep -i "CONSOLE=/dev/console")

echo -e "##########[S-01]root 계정 원격 접속 제한##########\n[root 계정 직접 접속 차단 여부]\n$ssh\n\n[원격 터미널 서비스 사용여부]\n$telnet" >> S1~73/log/[S-01]log.txt
cat S1~73/log/[S-01]log.txt >> S1~73/log.txt

if [ "$ssh" ];then
        if [ `echo "$ssh" | cut -c 1` == "#" ];then
                echo -e "A|[S-01] Root 원격접속에 대한 설정이 되어있지 않습니다 - [취약]" >> S1~73/bad/[S-01]bad.txt
		cat S1~73/bad/[S-01]bad.txt >> S1~73/inspect.txt
		echo -e "[S-01] vi 편집기를 사용하여 /etc/ssh/sshd_config 파일을 열어 PermitRootLogin 앞에 주석(#) 제거" >> S1~73/action/[S-01]action.txt
        else
                if echo "$ssh" | grep -i "yes" >/dev/null ;then
                        echo -e "A|[S-01] Root 원격접속이 허용되어 있습니다 - [취약]" >> S1~73/bad/[S-01]bad.txt
			cat S1~73/bad/[S-01]bad.txt >> S1~73/inspect.txt
			echo -e "[S-01] vi 편집기를 사용하여 /etc/ssh/sshd_config 파일을 열어 PermitRootLogin 뒤에 부분을 no로 변경" >> S1~73/action/[S-01]action.txt
                else
                        echo -e "A|[S-01] Root 원격접속이 차단되어 있거나 Key방식입니다 - [양호]" >> S1~73/good/[S-01]good.txt
			cat S1~73/good/[S-01]good.txt >> S1~73/inspect.txt
                fi
        fi
fi

if [ "$telnet" ];then
        if [ `echo "$telnet" | cut -c 1` == "#" ];then
                echo -e "A|[S-01] console이 지정된 디바이스로 제한되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-01]bad.txt
		cat S1~73/bad/[S-01]bad.txt >> S1~73/inspect.txt
		echo -e "[S-01] vi 편집기로 /etc/default/login 파일을 열어 CONSOLE=/dev/console 앞에 주석(#) 제거" >> S1~73/action/[S-01]action.txt
        else
                echo -e "A|[S-01] Root의 로그인 console을 제한하였습니다 - [양호]" >> S1~73/good/[S-01]good.txt
		cat S1~73/good/[S-01]good.txt >> S1~73/inspect.txt
        fi
else
        echo -e "A|[S-01] Root의 로그인 console 관련 설정이 없습니다 - [취약]" >> S1~73/bad/[S-01]bad.txt
	cat S1~73/bad/[S-01]bad.txt >> S1~73/inspect.txt
	echo -e "[S-01] vi 편집기로 /etc/default/login 파일을 열어 CONSOLE=/dev/console 신규 삽입" >> S1~73/action/[S-01]action.txt
fi
if [ -f "S1~73/action/[S-01]action.txt" ];then
	echo -e "[(S-01)조치사항]
[Telnet 서비스 사용 시]
1. vi 편집기를 이용하여 /etc/default/login 파일을 열기
2. CONSOLE=/dev/console 추가 또는 앞에 주석 제거

[SSH 서비스 사용 시]
1. vi 편집기를 이용하여 /etc/default/login 파일을 열기
2. PermitRootLogin 앞에 주석 제거 또는 뒤에 Yes가 있다면 No로 변경" >> S1~73/Action.txt
fi

##########[S-02]패스워드 복잡성 설정##########

passwd=$(cat /etc/default/passwd | egrep -i "mindiff|minalpha|minnonalpha|minupper|minlower|maxrepeats|minspecial|mindigit")
mindiff=$(cat /etc/default/passwd | grep -iw "mindiff")
minalpha=$(cat /etc/default/passwd | grep -iw "minalpha")
minnonalpha=$(cat /etc/default/passwd | grep -iw "minnonalpha")
minupper=$(cat /etc/default/passwd | grep -iw "minupper")
minlower=$(cat /etc/default/passwd | grep -iw "minlower")
maxrepeats=$(cat /etc/default/passwd | grep -iw "maxrepeats")
minspecial=$(cat /etc/default/passwd | grep -iw "minspecial")
mindigit=$(cat /etc/default/passwd | grep -iw "mindigit")

echo -e "\n##########[S-02]패스워드 복잡성 설정##########\n[/etc/default/passwd 파일 설정]\n$passwd" >> S1~73/log/[S-02]log.txt

cat S1~73/log/[S-02]log.txt >> S1~73/log.txt

if [ $mindiff ];then
        if [ `echo "$mindiff" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINDIFF : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
		echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 MINDIFF 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$mindiff" | awk -F"=" '{print$2}'` -ge 4 ];then
                        echo -e "A|[S-02] MINDIFF : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINDIFF : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
			echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 MINDIFF 값을 4 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $minalpha ];then
        if [ `echo "$minalpha" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINALPHA : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
		echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 MINALPHA 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$minalpha" | awk -F"=" '{print$2}'` -ge 1 ];then
                        echo -e "A|[S-02] MINALPHA : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINALPHA : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
			echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 MINALPHA 값을 1 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $minnonalpha ];then
        if [ `echo "$minnonalpha" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINNONALPHA : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 MINNONALPHA 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$minnonalpha" | awk -F"=" '{print$2}'` -ge 1 ];then
                        echo -e "A|[S-02] MINNONALPHA : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINNONALPHA : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                        echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 MINNONALPHA 값을 1 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $minupper ];then
        if [ `echo "$minupper" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINUPPER : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 minupper 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$minupper" | awk -F"=" '{print$2}'` -ge 1 ];then
                        echo -e "A|[S-02] MINUPPER : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINUPPER : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                        echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 minupper 값을 1 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $minlower ];then
        if [ `echo "$minlower" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINLOWER : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 minlower 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$minlower" | awk -F"=" '{print$2}'` -ge 1 ];then
                        echo -e "A|[S-02] MINLOWER : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINLOWER : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                        echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 minlower 값을 1 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $maxrepeats ];then
        if [ `echo "$maxrepeats" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MAXREPEATS : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 maxrepeats 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$maxrepeats" | awk -F"=" '{print$2}'` -eq 0 ];then
                        echo -e "A|[S-02] MAXREPEATS : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MAXREPEATS : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                        echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 maxrepeats 값을 0 으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $minspecial ];then
        if [ `echo "$minspecial" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINSPECIAL : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 minspecial 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$minspecial" | awk -F"=" '{print$2}'` -ge 1 ];then
                        echo -e "A|[S-02] MINSPECIAL : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINSPECIAL : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                        echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 minspecial 값을 1 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ $mindigit ];then
        if [ `echo "$mindigit" | cut -c 1` == "#" ]; then
                echo -e "A|[S-02] MINDIGIT : 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 mindigit 앞에 주석 제거" >> S1~73/action/[S-02]action.txt
        else
                if [ `echo "$mindigit" | awk -F"=" '{print$2}'` -ge 1 ];then
                        echo -e "A|[S-02] MINDIGIT : 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-02]good.txt
                else
                        echo -e "A|[S-02] MINDIGIT : 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-02]bad.txt
                        echo -e "[S-02] vi 편집기로 /etc/default/passwd 파일을 열어 mindigit 값을 1 이상으로 설정" >> S1~73/action/[S-02]action.txt
                fi
        fi
fi
if [ -f "S1~73/good/[S-02]good.txt" ];then
	cat S1~73/good/[S-02]good.txt >> S1~73/inspect.txt
fi
if [ -f "S1~73/bad/[S-02]bad.txt" ];then
	cat S1~73/bad/[S-02]bad.txt >> S1~73/inspect.txt
fi
if [ -f "S1~73/action/[S-02]action.txt" ];then
	echo -e "\n[(S-02)조치사항]
1. /etc/default/passwd 파일을 열어 아래 내부 정책에 맞도록 설정

[내부 정책]
HISTORY=10
MINDIFF=4
MINALPHA=1
MINNONALPHA=1
MINUPPER=1
MINLOWER=1
MAXREPEATS=0
MINSPECIAL=1
MINDIGIT=1
NAMECHECK=YES" >> S1~73/Action.txt
fi
##########[S-03]계정 잠금 임계값 설정##########

retry=$(cat /etc/default/login | grep -i "RETRIES=")
LockRetry=$(cat /etc/security/policy.conf | grep -i "LOCK_AFTER_RETRIES=")

echo -e "\n##########[S-03]계정 잠금 임계값 설정##########\n[계정 잠금 임계값]\n$retry\n$LockRetry" >> S1~73/log/[S-03]log.txt
cat S1~73/log/[S-03]log.txt >> S1~73/log.txt

if [ $retry ];then
        if [ `echo "$retry" | cut -c 1` == "#" ];then
                echo -e "A|[S-03] 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
		cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
		echo -e "[S-03]vi 편집기를 이용하여 /etc/default/login 파일을 열어 RETRIES= 앞에 주석 제거" >> S1~73/action/[S-03]action.txt
        else
                if [ `echo "$retry" | awk -F"=" '{print$2}'` -le 10 ];then
                        if [ `echo "$retry" | awk -F"=" '{print$2}'` -ge 1 ];then
                                echo -e "A|[S-03] 계정 잠금 임계값이 내부 정책에 맞도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-03]good.txt
				cat S1~73/good/[S-03]good.txt >> S1~73/inspect.txt
                        else
                                echo -e "A|[S-03] 계정 잠금 임계값이 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
				cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
				echo -e "[S-03]vi 편집기를 이용하여 /etc/default/login 파일을 열어 RETRIES= 뒤에 설정값을 0~10 사이로 설정" >> S1~73/action/[S-03]action.txt
                        fi
                else
                        echo -e "A|[S-03] 계정 잠금 임계값이 내부 정책에 맞도록 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
			cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
			echo -e "[S-03]vi 편집기를 이용하여 /etc/default/login 파일을 열어 RETRIES= 뒤에 설정값을 0~10 사이로 설정" >> S1~
73/action/[S-03]action.txt
                fi
        fi
else
        echo -e "A|[S-03] 계정 잠금 임계값 설정이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
	cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
	echo -e "[S-03]vi 편집기를 이용하여 /etc/default/login 파일을 열어 RETRIES= 10으로 설정" >> S1~73/action/[S-03]action.txt
fi
if [ $LockRetry ];then
        if [ `echo "$LockRetry" | cut -c 1` == "#" ];then
                echo -e "A|[S-03] 주석처리 되어 있습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
		cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
		echo -e "[S-03]vi 편집기를 이용하여 /etc/security/policy.conf 파일을 열어 LOCK_AFTER_RETRIES를 찾고 앞에 주석 제거" >> S1~73/action/[S-03]action.txt
        else
                if [ `echo "$LockRetry" | awk -F"=" '{print$2}'` == "YES" ];then
                        echo -e "A|[S-03] 일정 횟수 시도 후 잠금이 설정되었습니다 - [양호]" >> S1~73/good/[S-03]good.txt
			cat S1~73/good/[S-03]good.txt >> S1~73/inspect.txt
                else
                        echo -e "A|[S-03] 일정 횟수 시도 후 잠금이 설정되지 않았습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
			cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
			echo -e "[S-03]vi 편집기를 이용하여 /etc/security/policy.conf 파일을 열어 LOCK_AFTER_RETRIES= 뒤에 YES로 수정" >> S1~73/action/[S-03]action.txt
                fi
        fi
else
        echo -e "A|[S-03] 일정 횟수 시도 후 잠금 설정이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-03]bad.txt
	cat S1~73/bad/[S-03]bad.txt >> S1~73/inspect.txt
	echo -e "[S-03]vi 편집기를 이용하여 /etc/security/policy.conf 파일을 열어 LOCK_AFTER_RETRIES=YES 추가" >> S1~73/action/[S-03]action.txt
fi

if [ -f "S1~73/action/[S-03]action.txt" ];then
	echo -e "\n[(S-03)조치사항]
1. vi 편집기를 이용하여 /etc/default/login 파일 열기
2. 아래와 같이 수정 또는, 신규 삽입 (계정 잠금 횟수 설정)
RETRIES=10
3. vi 편집기를 이용하여 /etc/security/policy.conf 파일 열기
4. 아래와 같이 수정 또는, 신규 삽입 (계정 잠금 정책사용 설정)
LOCK_AFTER_RETRIES=YES" >> S1~73/Action.txt
fi

##########[S-04]패스워드 파일 보호##########

shadow=$(cat /etc/passwd | awk -F":" '{print$1" | "$2}')

echo -e "\n##########[S-04]패스워드 파일 보호##########\n[패스워드 암호화 확인]\n$shadow" >> S1~73/log/[S-04]log.txt
cat S1~73/log/[S-04]log.txt >> S1~73/log.txt

if [ `echo "$shadow" | grep -v "x" | wc -l` -eq 0 ];then
        echo -e "A|[S-04] 패스워드를 암호화해서 저장하고 있습니다 - [양호]" >> S1~73/good/[S-04]good.txt
	cat S1~73/good/[S-04]good.txt >> S1~73/inspect.txt
else
        echo -e "A|[S-04] 패스워드를 암호화해서 저장하지 않는 사용자가 존재합니다 - [취약]" >> S1~73/bad/[S-04]bad.txt
	cat S1~73/bad/[S-04]bad.txt >> S1~73/inspect.txt
	echo -e "[S-04]pwconv 명령어를 입력하여 패스워드 암호화 설정" >> S1~73/action/[S-04]action.txt
fi

if [ -f "S1~73/action/[S-04]action.txt" ];then
	echo -e "\n[(S-04)조치사항]
1. pwconv 입력(쉐도우 패스워드 정책 적용 방법)
2. pwunconv 입력 (일반 패스워드 정책 적용 방법)" >> S1~73/Action.txt
fi

##########[S-05]root 홈, 패스 디렉토리 권한 및 패스 설정##########

HOMEpath=$(cat /root/.profile | grep -i "PATH=")
ETCpath=$(cat /etc/profile | grep -i "PATH=")

echo -e "\n##########[S-05]root 홈, 패스 디렉토리 권한 및 패스 설정##########\n[PATH변수]\nHomePath=$HOMEpath\nEtcPath=$ETCpath" >> S1~73/log/[S-05]log.txt
cat S1~73/log/[S-05]log.txt >> S1~73/log.txt
echo -e "[S-05]log.txt과 action.txt 파일을 참고하여 PATH 환경변수를 확인" >> S1~73/bad/[S-05]bad.txt
echo -e "[S-05]vi 편집기를 이용하여 root 계정의 설정파일(~/.profile 과 /etc/profile)을 열어 '.', '::'이 맨 앞에 존재하는 경우 맨 뒤로 이동" >> S1~73/action/[S-05]action.txt

if [ -f "S1~73/action/[S-05]action.txt" ];then
        echo -e "\n[(S-05)조치사항]
1. vi 편집기를 이용하여 root 계정의 설정파일(~/.profile 과 /etc/profile) 열기
 vi /etc/profile
2. '.', '::'이 맨 앞, 중간에 존재하는 경우 아래 예시와 같이 수정
(수정 전) PATH=.:$PATH:$HOME/bin
(수정 후) PATH=$PATH:$HOME/bin:." >> S1~73/Action.txt
fi

##########[S-06]파일 및 디렉토리 소유자 설정##########

nouser=$(find / -nouser -xdev -ls 2> /dev/null)
nogroup=$(find / -nogroup -xdev -ls 2> /dev/null)

echo -e "\n##########[S-06]파일 및 디렉토리 소유자 설정##########\n[소유자가 존재하지 않는 파일 및 디렉토리]\n$nouser\n[그룹이 존재하지 않는 파일 및 디렉토리]\n$nogroup" >> S1~73/log/[S-06]log.txt
cat S1~73/log/[S-06]log.txt >> S1~73/log.txt

if [ "$nouser" ];then
        echo -e "B|[S-06] 소유자가 존재하지 않는 파일 및 디렉토리가 존재합니다 - [취약]" >> S1~73/bad/[S-06]bad.txt
	cat S1~73/bad/[S-06]bad.txt >> S1~73/inspect.txt
	echo -e "[S-06] 소유자가 존재하지 않는 파일이나 디렉토리가 불필요한 경우 rm 명령으로 삭제" >> S1~73/action/[S-06]action.txt
else
        echo -e "B|[S-06] 소유자가 존재하지 않는 파일 및 디렉토리가 존재하지 않습니다 - [양호]" >> S1~73/good/[S-06]good.txt
	cat S1~73/good/[S-06]good.txt >> S1~73/inspect.txt
fi
if [ "$nogroup" ];then
        echo -e "B|[S-06] 그룹이 존재하지 않는 파일 및 디렉토리가 존재합니다 - [취약]" >> S1~73/bad/[S-06]bad.txt
	cat S1~73/bad/[S-06]bad.txt >> S1~73/inspect.txt
	echo -e "[S-06] 그룹이 존재하지 않는 파일 및 디렉토리가 존재하는 경우 rm 명령으로 삭제" >> S1~73/action/[S-06]action.txt
else
        echo -e "B|[S-06] 그룹이 존재하지 않는 파일 및 디렉토리가 존재하지 않습니다 - [양호]" >> S1~73/good/[S-06]good.txt
	cat S1~73/good/[S-06]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-06]action.txt" ];then
        echo -e "\n[(S-06)조치사항]
1. 소유자, 그룹이 존재하지 않는 파일이나 디렉터리가 불필요한 경우 rm 명령으로 삭제
 rm <file_name>
 rm -rf <directory_name>
2. 필요한 경우 chown 명령으로 소유자 및 그룹 변경
 chown <user_name> <file_name>" >> S1~73/Action.txt
fi

##########[S-07]/etc/passwd 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc/passwd | awk '{print$3}')
stat2=$(stat -c '%a' /etc/passwd)

echo -e "\n##########[S-07]/etc/passwd 파일 소유자 및 권한 설정##########\n파일 소유자 : $stat\n파일 권한 : $stat2" >> S1~73/log/[S-07]log.txt
cat S1~73/log/[S-07]log.txt >> S1~73/log.txt

if [ "$stat" == "root" ];then
        echo -e "B|[S-07] 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-07]good.txt
	cat S1~73/good/[S-07]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-07] 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-07]bad.txt
	cat S1~73/bad/[S-07]bad.txt >> S1~73/inspect.txt
	echo -e "[S-07] chown 명령으로 /etc/passwd 파일의 소유자를 root로 변경" >> S1~73/action/[S-07]action.txt
fi
if [ "$stat2" -le "644" ];then
        echo -e "B|[S-07] 파일의 권한이 644 이하입니다 - [양호]" >> S1~73/good/[S-07]good.txt
	cat S1~73/good/[S-07]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-07] 파일의 권한이 644 보다 높습니다 - [취약]" >> S1~73/bad/[S-07]bad.txt
	cat S1~73/bad/[S-07]bad.txt >> S1~73/inspect.txt
	echo -e "[S-07] chmod 명령으로 /etc/passwd 파일의 권한을 644 이하로 설정" >> S1~73/action/[S-07]action.txt
fi

if [ -f "S1~73/action/[S-07]action.txt" ];then
        echo -e "\n[(S-07)조치사항]
/etc/passwd 파일의 소유자 및 권한 변경 (소유자 root, 권한 644이하)
 chown root /etc/passwd
 chmod 644 /etc/passwd" >> S1~73/Action.txt
fi

##########[S-08]/etc/shadow 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc/shadow | awk '{print$3}')
stat2=$(stat -c '%a' /etc/shadow)

echo -e "\n##########[S-08]/etc/shadow 파일 소유자 및 권한 설정##########\n파일 소유자 : $stat\n파일 권한 : $stat2" >> S1~73/log/[S-08]log.txt
cat S1~73/log/[S-08]log.txt >> S1~73/log.txt

if [ "$stat" == "root" ];then
        echo -e "B|[S-08] 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-08]good.txt
	cat S1~73/good/[S-08]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-08] 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-08]bad.txt
	cat S1~73/bad/[S-08]bad.txt >> S1~73/inspect.txt
	echo -e "[S-08] chown 명령으로 /etc/shadow 파일의 소유자를 root로 변경" >> S1~73/action/[S-08]action.txt
fi
if [ "$stat2" -le "400" ];then
        echo -e "B|[S-08] 파일의 권한이 400 이하입니다 - [양호]" >> S1~73/good/[S-08]good.txt
	cat S1~73/good/[S-08]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-08] 파일의 권한이 400 보다 높습니다 - [취약]" >> S1~73/bad/[S-08]bad.txt
	cat S1~73/bad/[S-08]bad.txt >> S1~73/inspect.txt
	echo -e "[S-08] chmod 명령으로 /etc/shadow 파일의 권한을 400 이하로 설정" >> S1~73/action/[S-08]action.txt
fi

if [ -f "S1~73/action/[S-08]action.txt" ];then
        echo -e "\n[(S-08)조치사항]
/etc/shadow 파일의 소유자 및 권한 변경(소유자 root, 권한 400 이하)
 chown root /etc/shadow
 chmod 400 /etc/shadow" >> S1~73/Action.txt
fi

##########[S-09]/etc/hosts 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc/hosts | awk '{print$3}')
stat2=$(stat -c '%a' /etc/hosts)
stat3=$(stat -c '%a' /etc/inet/hosts)

echo -e "##########[S-09]/etc/hosts 파일 소유자 및 권한 설정##########\n파일 소유자 : $stat\n[파일 권한]\n/etc/hosts : $stat2\n/etc/inet/hosts : $stat3" >> S1~73/log/[S-09]log.txt
cat S1~73/log/[S-09]log.txt >> S1~73/log.txt

if [ "$stat" == "root" ];then
        echo -e "B|[S-09] 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-09]good.txt
	cat S1~73/good/[S-09]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-09] 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-09]bad.txt
	cat S1~73/bad/[S-09]bad.txt >> S1~73/inspect.txt
	echo -e "[S-09] chown 명령으로 /etc/hosts 파일의 소유자를 root로 변경" >> S1~73/action/[S-09]action.txt
fi
if [ "$stat2" -le "600" ];then
        echo -e "B|[S-09] 파일의 권한이 600 이하입니다 - [양호]" >> S1~73/good/[S-09]good.txt
	cat S1~73/good/[S-09]good.txt >> S1~73/inspect.txt
else
        if [ "$stat3" -le "600" ];then
                echo -e "B|[S-09] /etc/hosts의 파일권한은 777이지만, 심볼릭링크로 연결된 /etc/inet/hosts의 파일권한이 600 이하입니다 - [양호]" >> S1~73/good/[S-09]good.txt
		cat S1~73/good/[S-09]good.txt >> S1~73/inspect.txt
        else
                echo -e "B|[S-09] /etc/hosts 파일과 심볼릭링크로 연결된 /etc/inet/hosts 파일 모두 권한이 600보다 높습니다 - [취약]" >> S1~73/bad/[S-09]bad.txt
		cat S1~73/bad/[S-09]bad.txt >> S1~73/inspect.txt
		echo -e "[S-09] chmod 명령으로 /etc/inet/hosts 파일의 권한을 600 이하로 설정" >> S1~73/action/[S-09]action.txt
        fi
fi

if [ -f "S1~73/action/[S-09]action.txt" ];then
        echo -e "\n[(S-09)조치사항]
/etc/hosts 파일과 /etc/inet/hosts 파일의 소유자 및 권한 변경(소유자 root, 권한 600) chown root /etc/hosts, chown root /etc/inet/hosts
 chmod 600 /etc/inet/hosts" >> S1~73/Action.txt
fi

##########[S-10]/etc/inetd.conf 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc/inetd.conf | awk '{print$3}')
stat2=$(stat -c '%a' /etc/inetd.conf)
stat3=$(stat -c '%a' /etc/inet/inetd.conf)

echo -e "##########[S-10]/etc/inetd.conf 파일 소유자 및 권한 설정##########\n파일 소유자 : $stat\n[파일 권한]\n/etc/hosts : $stat2\n/etc/inet/hosts : $stat3" >> S1~73/log/[S-10]log.txt
cat S1~73/log/[S-10]log.txt >> S1~73/log.txt

if [ "$stat" == "root" ];then
        echo -e "B|[S-10] 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-10]good.txt
	cat S1~73/good/[S-10]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-10] 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-10]bad.txt
	cat S1~73/bad/[S-10]bad.txt >> S1~73/inspect.txt
	echo -e "[S-10] chown 명령으로 /etc/inetd.conf 파일의 소유자를 root 로 변경" >> S1~73/action/[S-10]action.txt
fi
if [ "$stat2" -le "600" ];then
        echo -e "B|[S-10] 파일의 권한이 600 이하입니다 - [양호]" >> S1~73/good/[S-10]good.txt
	cat S1~73/good/[S-10]good.txt >> S1~73/inspect.txt
else
        if [ "$stat3" -le "600" ];then
                echo -e "B|[S-10]/etc/inetd.conf의 파일권한은 777이지만, 심볼릭링크로 연결된 /etc/inet/inetd.conf의 파일권한이 600 입니다 - [양호]" >> S1~73/good/[S-10]good.txt
		cat S1~73/good/[S-10]good.txt >> S1~73/inspect.txt
        else
                echo -e "B|[S-10]/etc/inetd.conf 파일과 심볼릭링크로 연결된 /etc/inet/inetd.conf 파일 모두 권한이 600보다 높습니다 - [취약]" >> S1~73/bad/[S-10]bad.txt	
		cat S1~73/bad/[S-10]bad.txt >> S1~73/inspect.txt
		echo -e "[S-10] chmod 명령으로 /etc/inet/inetd.conf 파일의 권한을 600 이하로 설정" >> S1~73/action/[S-10]action.txt
        fi
fi

if [ -f "S1~73/action/[S-10]action.txt" ];then
        echo -e "\n[(S-10)조치사항]
/etc/inetd.conf 파일과 /etc/inet/inetd.conf 파일의 소유자 및 권한 변경(소유자 root, 권한 600)
 chown root /etc/inetd.conf, chown root /etc/inet/inetd.conf
 chmod 600 /etc/inet/inetd.conf" >> S1~73/Action.txt
fi

##########[S-11]/etc/syslog.conf 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc/syslog.conf | awk '{print$3}')
stat2=$(stat -c '%a' /etc/syslog.conf)

echo -e "##########[S-11]/etc/syslog.conf 파일 소유자 및 권한 설정##########\n파일 소유자 : $stat\n파일 권한 : $stat2" >> S1~73/log/[S-11]log.txt
cat S1~73/log/[S-11]log.txt >> S1~73/log.txt

if [ "$stat" == "root" ];then
        echo -e "B|[S-11] 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-11]good.txt
	cat S1~73/good/[S-11]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-11] 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-11]bad.txt
	cat S1~73/bad/[S-11]bad.txt >> S1~73/inspect.txt
	echo -e "[S-11] chown 명령으로 /etc/syslog.conf 파일의 소유자를 root로 변경" >> S1~73/action/[S-11]action.txt
fi
if [ "$stat2" -le "640" ];then
        echo -e "B|[S-11] 파일의 권한이 640 이하입니다 - [양호]" >> S1~73/good/[S-11]good.txt
	cat S1~73/good/[S-11]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-11] 파일의 권한이 640보다 높습니다 - [취약]" >> S1~73/bad/[S-11]bad.txt
	cat S1~73/bad/[S-11]bad.txt >> S1~73/inspect.txt
	echo -e "[S-11] chmod 명령으로 /etc/syslog.conf 파일의 권한을 640 이하로 설정" >> S1~73/action/[S-11]action.txt
fi

if [ -f "S1~73/action/[S-11]action.txt" ];then
        echo -e "\n[(S-11)조치사항]
/etc/syslog.conf 파일의 소유자 및 권한 변경 (소유자 root, 권한 644)
 chown root /etc/syslog.conf
 chmod 640 /etc/syslog.conf" >> S1~73/Action.txt
fi

##########[S-12]/etc/services 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc/services | awk '{print$3}')
stat2=$(stat -c '%a' /etc/services)
stat3=$(stat -c '%a' /etc/inet/services)

echo -e "##########[S-12]/etc/services 파일 소유자 및 권한 설정##########\n파일 소유자 : $stat\n[파일 권한]\n/etc/services : $stat2\n/etc/inet/services : $stat3" >> S1~73/log/[S-12]log.txt
cat S1~73/log/[S-12]log.txt >> S1~73/log.txt

if [ "$stat" == "root" ];then
        echo -e "B|[S-12] 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-12]good.txt
	cat S1~73/good/[S-12]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-12] 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-12]bad.txt
	cat S1~73/bad/[S-12]bad.txt >> S1~73/inspect.txt
	echo -e "[S-12] chown 명령으로 /etc/services 파일의 소유자를 root로 설정" >> S1~73/action/[S-12]action.txt
fi
if [ "$stat2" -le "644" ];then
        echo -e "B|[S-12] 파일의 권한이 644 이하입니다 - [양호]" >> S1~73/good/[S-12]good.txt
	cat S1~73/good/[S-12]good.txt >> S1~73/inspect.txt
else
        if [ "$stat3" -le "644" ];then
                echo -e "B|[S-12]/etc/services의 파일권한은 777이지만, 심볼릭링크로 연결된 /etc/inet/services의 파일권한이 644 이하 입니다 - [양호]" >> S1~73/good/[S-12]good.txt
		cat S1~73/good/[S-12]good.txt >> S1~73/inspect.txt
        else
                echo -e "B|[S-12]/etc/services 파일과 심볼릭링크로 연결된 /etc/inet/services 파일 모두 권한이 644보다 높습니다 - [취약]" >> S1~73/bad/[S-12]bad.txt
		cat S1~73/bad/[S-12]bad.txt >> S1~73/inspect.txt
		echo -e "[S-12] chmod 명령으로 /etc/inet/services 파일의 권한을 644 이하로 설정" >> S1~73/action/[S-12]action.txt
        fi
fi

if [ -f "S1~73/action/[S-12]action.txt" ];then
        echo -e "\n[(S-12)조치사항]
/etc/services 파일과 /etc/inet/services 파일의 소유자 및 권한 변경(소유자 root, 권한644)
 chown root /etc/services, chown root /etc/inet/services
 chmod 644 /etc/inet/services" >> S1~73/Action.txt
fi

##########[S-13]SUID, SGID 설정 파일 점검##########

stat=$(find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al {} \;)

echo -e "\n##########[S-13]SUID, SGID 설정 파일 점검##########\n[SUID, SGID 설정 부여되어 있는 파일]\n$stat" >> S1~73/log/[S-13]log.txt
cat S1~73/log/[S-13]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        echo -e "B|[S-13] 주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있습니다 - [취약]" >> S1~73/bad/[S-13]bad.txt
	cat S1~73/bad/[S-13]bad.txt >> S1~73/inspect.txt
	echo -e "[S-13] chmod -s <file_name>으로 주요 실행파일의 권한에 SUID, SGID에 대한 설정을 제거" >> S1~73/action/[S-13]action.txt
else
        echo -e "B|[S-13] 주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않습니다 - [양호]" >> S1~73/good/[S-13]good.txt
	cat S1~73/good/[S-13]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-13]action.txt" ];then
        echo -e "\n[(S-13)조치사항]
1. 제거 방법
 chmod -s <file_name>
2. 주기적인 감사방법
 find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al {} \;" >> S1~73/Action.txt
fi

##########[S-14]사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정##########

RootPerm=$(find /root -type f \( -name "*.profile" -o -name "*.kshrc" -o -name "*.cshrc" -o -name "*.bashrc" -o -name "*.bash_profile" -o -name "*.login" -o -name "*.exrc" -o -name "*.netrc" \) -perm -o=w,g=w -exec ls -al {} \;)
RootOwn=$(find /root -type f \( -name "*.profile" -o -name "*.kshrc" -o -name "*.cshrc" -o -name "*.bashrc" -o -name "*.bash_profile" -o -name "*.login" -o -name "*.exrc" -o -name "*.netrc" \) ! -user root -exec ls -al {} \;)

echo -e "\n##########[S-14]사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정##########\n[환경변수 파일 소유자]\n$RootOwn\n[환경변수 파일 권한]\n$RootOwn" >> S1~73/log/[S-14]log.txt
cat S1~73/log/[S-14]log.txt >> S1~73/log.txt

if [ "$RootPerm" ];then
	echo -e "B|[S-14] 홈 디렉토리 환경변수 파일이 그룹과 다른 사용자에게 쓰기권한이 부여되어 있습니다 - [취약]" >> S1~73/bad/[S-14]bad.txt
	cat S1~73/bad/[S-14]bad.txt >> S1~73/inspect.txt
	echo -e "[S-14] chmod o-w <file_name> 명령으로 일반 사용자 쓰기 권한 제거" >> S1~73/action/[S-14]action.txt
else
	echo -e "B|[S-14] 홈 디렉토리 환경변수 파일이 소유자에게만 쓰기권한이 부여되어 있습니다 - [양호]" >> S1~73/good/[S-14]good.txt
	cat S1~73/good/[S-14]good.txt >> S1~73/inspect.txt
fi
if [ "$RootOwn" ];then
	echo -e "B|[S-14] 홈 디렉토리 환경변수 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-14]bad.txt
	cat S1~73/bad/[S-14]bad.txt >> S1~73/inspect.txt
	echo -e "[S-14] chown 명령으로 환경변수 파일의 소유자를 root로 변경" >> S1~73/action/[S-14]action.txt
else
	echo -e "B|[S-14] 홈 디렉토리 환경변수 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-14]good.txt
	cat S1~73/good/[S-14]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-14]action.txt" ];then
        echo -e "\n[(S-14)조치사항]
1. 소유자 변경 방법
 chown <user_name> <file_name>
2. 일반 사용자 쓰기 권한 제거 방법
 chmod o-w <file_name>" >> S1~73/Action.txt
fi

##########[S-15]world writable 파일 점검##########

stat=$(find / -type f -perm -2 -exec ls -l {} \;)

echo -e "\n##########[S-15]world writable 파일 점검##########\n[world writable 파일]\n$stat" >> S1~73/log/[S-15]log.txt
cat S1~73/log/[S-15]log.txt >> S1~73/log.txt

if [ "$stat" ];then
	echo -e "B|[S-15] world writable 파일이 존재합니다 - [취약]" >> S1~73/bad/[S-15]bad.txt
	cat S1~73/bad/[S-15]bad.txt >> S1~73/inspect.txt
	echo -e "[S-15] rm 명령으로 world writable 파일 제거" >> S1~73/action/[S-15]action.txt
else
	echo -e "B|[S-15] world writable 파일이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-15]good.txt
	cat S1~73/good/[S-15]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-]action.txt" ];then
        echo -e "\n[(S-)조치사항]
파일 삭제 방법
 rm -rf <world-writable 파일명>" >> S1~73/Action.txt
fi

##########[S-16]/dev에 존재하지 않는 device 파일 점검##########

stat=$(find /dev -type f -exec ls -l {} \;)

echo -e "\n##########[S-16] /dev에 존재하지 않는 device 파일 점검##########\n[dev에 존재하지 않는 파일]\n$stat" >> S1~73/log/[S-16]log.txt
cat S1~73/log/[S-16]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        echo -e "B|[S-16] /dev에 존재하지 않는 device 파일이 존재합니다 - [취약]" >> S1~73/bad/[S-16]bad.txt
	cat S1~73/bad/[S-16]bad.txt >> S1~73/inspect.txt
	echo -e "[S-16] ls -l 명령으로 해당 파일의 major, minor number를 확인하고 없을 경우 삭제" >> S1~73/action/[S-16]action.txt
else
        echo -e "B|[S-16] /dev에 존재하지 않는 device 파일이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-16]good.txt
	cat S1~73/good/[S-16]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-16]action.txt" ];then
        echo -e "\n[(S-16)조치사항]
1. /dev 디렉토리 파일 점검
 find /dev -type f -exec ls -l {} \;
2. major, minor number를 가지지 않는 device일 경우 삭제
major, minor 번호는 ls -l 명령으로 어느 파일을 보았을 때 5, 6번째 영역에 있는 번호이다" >> S1~73/Action.txt
fi

##########[S-17]$HOME/.rhosts, hosts.equiv 사용 금지##########

equiv=$(ls -al /etc/ | grep -i "hosts.equiv")
equiv_u=$(ls -al /etc/ | grep -i "hosts.equiv" | awk '{print$3}')
equiv_mod=$(stat -c '%a' /etc/hosts.equiv 2>/dev/null)
rhosts=$(ls -al $HOME/ | grep -i ".rhosts")
rhosts_h_u=`ls -al $HOME/ | grep -i ".rhosts" | awk '{print$3}'`
rhosts_h_mod=`stat -c '%a' $HOME/.rhosts 2>/dev/null`

echo -e "##########[S-17]$HOME/.rhosts, hosts.equiv 사용 금지##########\n[/etc/hosts.equiv 파일]\n소유자 : $equiv_u\n파일 권한 : $equiv_mod\n[\$Home/.rhosts 파일]\n소유자 : $rhosts_h_u\n파일 권한 : $rhosts_h_mod" >> S1~73/log/[S-17]log.txt
cat S1~73/log/[S-17]log.txt >> S1~73/log.txt

if [ $equiv ];then
        if [ "$equiv_u" == "root" ];then
                if [ "$equiv_mod" -le "600" ];then
                        echo -e "B|[S-17] /etc/hosts.equiv 파일의 권한이 600 이하입니다 - [양호]" >> S1~73/good/[S-17]good.txt
			cat S1~73/good/[S-17]good.txt >> S1~73/inspect.txt
                else
                        echo -e "B|[S-17] /etc/hosts.equiv 파일의 권한이 600 보다 높습니다 - [취약]" >> S1~73/bad/[S-17]bad.txt
			cat S1~73/bad/[S-17]bad.txt >> S1~73/inspect.txt
			echo -e "[S-17] chmod 명령으로 파일 권한을 600 이하로 설정" >> S1~73/action/[S-17]action.txt
                fi
        else
                echo -e "B|[S-17] /etc/hosts.equiv 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-17]bad.txt
		cat S1~73/bad/[S-17]bad.txt >> S1~73/inspect.txt
		echo -e "[S-17] chown 명령으로 파일의 소유자를 root 로 변경" >> S1~73/action/[S-17]action.txt
        fi
else
        echo -e "B|[S-17] /etc/hosts.equiv 파일이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-17]good.txt
	cat S1~73/good/[S-17]good.txt >> S1~73/inspect.txt
fi


if [ $rhosts ];then
        if [ "$rhosts_h_u" == "root" ];then
                if [ "$rhosts_h_mod" -le "600" ];then
                        echo -e "B|[S-17] $HOME/.rhosts 파일 권한이 600 이하입니다 - [양호]" >> S1~73/good/[S-17]good.txt
			cat S1~73/good/[S-17]good.txt >> S1~73/inspect.txt
                else
                        echo -e "B|[S-17] $HOME/.rhosts 파일의 권한이 600 보다 높습니다 - [취약]" >> S1~73/bad/[S-17]bad.txt
			cat S1~73/bad/[S-17]bad.txt
			echo -e "[S-17] chmod 명령으로 $HOME/.rhosts 파일의 권한을 600 이하로 설정" >> S1~73/action/[S-17]action.txt
                fi
        else
                echo -e "B|[S-17] $HOME/.rhosts 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-17]bad.txt
		cat S1~73/bad/[S-17]bad.txt >> S1~73/inspect.txt
		echo -e "[S-17] chown 명령으로 $HOME/.rhosts 파일의 소유자를 root 로 설정" >> S1~73/action/[S-17]action.txt
        fi
else
        echo -e "B|[S-17] $HOME/.rhosts 파일이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-17]good.txt
	cat S1~73/good/[S-17]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-17]action.txt" ];then
        echo -e "\n[(S-17)조치사항]
/etc/hosts.equiv 파일 및 $HOME/.rhosts 파일의 소유자를 root로 변경, 파일의 권한을 600 이하로 설정
 chown root /etc/hosts.equiv
 chmod 600 /etc/hosts.equiv
 chown root $HOME/.rhosts
 chmod 600 $HOME/.rhosts" >> S1~73/Action.txt
fi

##########[S-18]접속 IP 및 포트 제한##########

allow=$( [ -f "/etc/hosts.allow" ] && cat "/etc/hosts.allow" )
deny=$( [ -f "/etc/hosts.deny" ] && cat "/etc/hosts.deny" )

echo -e "\n##########[S-18] 접속 IP 및 포트 제한##########\n[Allow 여부]\n$allow\n[Deny 여부]\n$deny" >> S1~73/log/[S-18]log.txt
cat S1~73/log/[S-18]log.txt >> S1~73/log.txt

if [ "$(echo "$allow" | wc -l)" -ge 1 ];then
        echo -e "B|[S-18] 허용할 IP주소를 설정하였습니다 - [양호]" >> S1~73/good/[S-18]good.txt
	cat S1~73/good/[S-18]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-18] 허용할 IP주소를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-18]bad.txt
	cat S1~73/bad/[S-18]bad.txt >> S1~73/inspect.txt
	echo -e "[S-18] /etc/hosts.allow 파일에 허용할 IP 주소 추가" >> S1~73/action/[S-18]action.txt
fi
if [ "$(echo "$deny" | wc -l)" -ge 1 ];then
        echo -e "B|[S-18] 거부할 IP 주소를 설정하였습니다 - [양호]" >> S1~73/good/[S-18]good.txt
	cat S1~73/good/[S-18]good.txt >> S1~73/inspect.txt
else
        echo -e "B|[S-18] 거부할 IP 주소를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-18]bad.txt
	cat S1~73/bad/[S-18]bad.txt >> S1~73/inspect.txt
	echo -e "[S-18] /etc/hosts.deny 파일에 거부할 IP 주소 추가" >> S1~73/action/[S-18]action.txt
fi

if [ -f "S1~73/action/[S-18]action.txt" ];then
        echo -e "\n[(S-18)조치사항]
/etc/hosts.allow 파일 및 /etc/hosts.deny 파일에 허용, 거부할 IP 추가
만약 존재하지 않을 시 vi 또는 touch 명령으로 새로 생성 후 추가" >> S1~73/Action.txt
fi

##########[S-19]Finger 서비스 비활성화##########

finger_check=$(inetadm | grep "finger")

echo -e "\n##########[S-19] Finger 서비스 비활성화##########\n[Finger 서비스 사용여부]\n$finger_check" >> S1~73/log/[S-19]log.txt
cat S1~73/log/[S-19]log.txt >> S1~73/log.txt

if [ "$(echo "$finger_check" | awk '{print$1}')" == "disabled" ];then
        echo -e "C|[S-19] Finger 서비스가 비활성화 되어 있습니다 - [양호]" >> S1~73/good/[S-19]good.txt
	cat S1~73/good/[S-19]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-19] Finger 서비스가 활성화 되어 있습니다 - [취약]" >> S1~73/bad/[S-19]bad.txt
	cat S1~73/bad/[S-19]bad.txt >> S1~73/inspect.txt
	echo -e "[S-19] inetadm -d 명령으로 중지하고자 하는 데몬 중지" >> S1~73/action/[S-19]action.txt
fi

if [ -f "S1~73/action/[S-19]action.txt" ];then
        echo -e "\n[(S-19)조치사항]
inetadm -d <중지하고자 하는 데몬> 명령으로 서비스 데몬 중지
예) inetadm -d svc:/network/finger:default" >> S1~73/Action.txt
fi

##########[S-20]Anonymous FTP 비활성화##########

ftp=$(cat /etc/passwd | grep "ftp")

echo -e "\n##########[S-20]Anonymous FTP 비활성화##########\n[anonymous FTP 사용 여부]\n$ftp" >> S1~73/log/[S-20]log.txt
cat S1~73/log/[S-20]log.txt >> S1~73/log.txt

if [ "$ftp" ];then
        echo -e "C|[S-20] Anonymous FTP 접속이 차단되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-20]bad.txt
	cat S1~73/bad/[S-20]bad.txt >> S1~73/inspect.txt
	echo -e "[S-20] /etc/passwd 파일에서 ftp 또는 anonymous 계정 삭제" >> S1~73/action/[S-20]action.txt
else
        echo -e "C|[S-20] Anonymous FTP 접속이 차단되어 있습니다 - [양호]" >> S1~73/good/[S-20]good.txt
	cat S1~73/good/[S-20]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-20]action.txt" ];then
        echo -e "\n[(S-20)조치사항]
1. 일반 FTP - Anonymous FTP 접속 제한 설정 방법
/etc/passwd 파일에서 ftp 또는, anonymous 계정 삭제
 SOLARIS, LINUX, HP-UX 설정: userdel ftp
 AIX 설정: rmuser ftp

2. ProFTP - Anonymous FTP 접속 제한 설정 방법
 conf/proftpd.conf 파일의 anonymous 관련 설정 중 User, Useralias 항목 주석처리
 (proftpd.conf 파일의 위치는 운영체제 종류별로 상이함)
 <Anonymous ~ftp>
 # User ftp 
 Group ftp
 # UserAlias anonymous ftp 
~~이하생략~~
 </Anonymous>

3. vsFTP - Anonymous FTP 접속 제한 설정 방법
 vsFTP 설정파일(/etc/vsftpd/vsftpd.conf 또는, /etc/vsftpd.conf)에서
 anonymous_enable=NO 설정" >> S1~73/Action.txt
fi

##########[S-21]r 계열 서비스 비활성화##########

r_service=$(inetadm | egrep -i "shell|rlogin|rexec")

echo -e "\n##########[S-21] r 계열 서비스 비활성화##########\n[존재하는 r 계열 서비스]\n$r_service" >> S1~73/log/[S-21]log.txt
cat S1~73/log/[S-21]log.txt >> S1~73/log.txt

if [ "$r_service" ];then
        if [ `echo "$r_service" | grep -c enable` -ge 1 ];then
                echo -e "C|[S-21] r 계열 서비스가 존재하고, 활성화 상태입니다 - [취약]" >> S1~73/bad/[S-21]bad.txt
		cat S1~73/bad/[S-21]bad.txt >> S1~73/inspect.txt
		echo -e "[S-21] inetadm -d <중지하고자 하는 데몬> 명령으로 중지" >> S1~73/action/[S-21]action.txt
        else
                echo -e "C|[S-21] r 계열 서비스가 존재하지만 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-21]good.txt
		cat S1~73/good/[S-21]good.txt >> S1~73/inspect.txt
        fi
else
        echo -e "C|[S-21] r 계열 서비스가 존재하지 않습니다 - [양호]" >> S1~73/good/[S-21]good.txt
	cat S1~73/good/[S-21]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-21]action.txt" ];then
        echo -e "\n[(S-21)조치사항]
1. rcommand 관련 데몬 확인
 svc:/network/login:rlogin
 svc:/network/rexec:default
 svc:/network/shell:kshell

2. ientadm -d <중지하고자 하는 데몬> 명령으로 중지" >> S1~73/Action.txt
fi

##########[S-22]crond 파일 소유자 및 권한 설정##########

cron_path=`find /usr/bin/ -name crontab`
cron_mod=$(stat -c '%a' $cron_path)
etc_cron_own=$(ls -l /etc/cron.d | awk '$3 != "root"' | grep -v total | wc -l)
etc_cron_mod=$(stat -c '%a' /etc/cron.d/* | awk '$1 > 640' | grep -v total | wc -l)

echo -e "\n##########[S-22] crond 파일 소유자 및 권한 설정##########\n[crontab 경로]\n$cron_path\n[crontab 권한]\n$cron_mod\n/etc/cron.d 소유자 : $etc_cron_own\n/etc/cron.d 권한 : $etc_cron_mod" >> S1~73/log/[S-22]log.txt
cat S1~73/log/[S-22]log.txt >> S1~73/log.txt

if [ "$cron_mod" ];then
        if [ "$cron_mod" -ge "0" ];then
                if [ "$cron_mod" -le "750" ];then
			echo -e "C|[S-22] cron_path 권한이 750 이하입니다 - [양호]" >> S1~73/good/[S-22]good.txt
			cat S1~73/good/[S-22]good.txt >> S1~73/inspect.txt
                else
                        echo -e "C|[S-22] cron_path에 SUID가 설정되어 있거나 권한이 750 보다 높습니다 - [취약]" >> S1~73/bad/[S-22]bad.txt
			cat S1~73/bad/[S-22]bad.txt >> S1~73/inspect.txt
			echo -e "[S-22] chmod 명령으로 crond 파일 권한을 750 이하로 설정" >> S1~73/action/[S-22]action.txt
                fi
        fi
else
        echo -e "C|[S-22]/usr/bin 내에 crontab 파일이 없습니다 - [양호]" >> S1~73/good/[S-22]good.txt
	cat S1~73/good/[S-22]good.txt >> S1~73/inspect.txt
fi
if [ "$etc_cron_own" -ge 1 ];then
        echo -e "C|[S-22]폴더 내 cron 관련 설정파일 중 소유자가 root 아닌 파일이 존재합니다 - [취약]" >> S1~73/bad/[S-22]bad.txt
	cat S1~73/bad/[S-22]bad.txt >> S1~73/inspect.txt
	echo -e "[S-22] chown 명령으로 /etc/cron.d 폴더 내 소유자가 root 가 아닌 파일의 소유자를 root로 설정" >> S1~73/action/[S-22]action.txt
else
        echo -e "C|[S-22]폴더 내 모든 cron 관련 설정파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-22]good.txt
	cat S1~73/good/[S-22]good.txt >> S1~73/inspect.txt
fi
if [ "$etc_cron_mod" -ge 1 ];then
        echo -e "C|[S-22]폴더 내 cron 관련 설정파일 중 파일 권한이 640보다 높은 파일이 있습니다 - [취약]" >> S1~73/bad/[S-22]bad.txt
	cat S1~73/bad/[S-22]bad.txt >> S1~73/inspect.txt
	echo -e "[S-22] chmod 명령으로 /etc/cron.d 폴더 내 파일 중 파일권한이 640 이하가 아닌 파일의 권한을 640 이하로 설정" >> S1~73/action/[S-22]action.txt
else
        echo -e "C|[S-22]폴더 내 모든  cron 관련 설정파일의 파일권한이 640 이하입니다 - [양호]" >> S1~73/good/[S-22]good.txt
	cat S1~73/bad/[S-22]bad.txt >> S1~73/inspect.txt

fi

if [ -f "S1~73/action/[S-22]action.txt" ];then
        echo -e "\n[(S-22)조치사항]
/usr/bin 폴더 내 cron 관련 파일 및 /etc/cron.d 폴더 내 파일들의 소유자를 root로 설정 및 /usr/bin 폴더 내 cron 관련 파일의 권한은 750이하, /et/cron.d 폴더 내 파일의 권한은 640 이하로 설정" >> S1~73/Action.txt
fi

##########[S-23]DoS 공격에 취약한 서비스 비활성화##########

stat=$(inetadm | egrep "echo|discard|daytime|chargen")

echo -e "\n##########[S-23]DoS 공격에 취약한 서비스 비활성화##########\n[DoS 관련 서비스 현황]\n$stat" >> S1~73/log/[S-23]log.txt
cat S1~73/log/[S-23]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep enable)" ];then
        echo -e "C|[S-23]DoS 공격에 취약한 서비스가 활성화 상태입니다 - [취약]" >> S1~73/bad/[S-23]bad.txt
	cat S1~73/bad/[S-23]bad.txt >> S1~73/inspect.txt
	echo -e "[S-23]svcadm disable <비활성화 할 서비스 이름> 명령으로 echo,discard,daytime,chargen 서비스 비활성화" >> S1~73/action/[S-23]action.txt
else
        echo -e "C|[S-23]DoS 공격에 취약한 서비스가 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-23]good.txt
	cat S1~73/good/[S-23]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-23]action.txt" ];then
        echo -e "\n[(S-23)조치사항]
1. echo 서비스 비활성화 설정
 svcs -a |grep echo
 svcadm disable svc:/network/echo:dgrm
 svcadm disable svc:/network/echo:stream
2. discard 서비스 비활성화 설정
 svcs -a |grep daytime
 svcadm disable svc:/network/daytime:dgram
 svcadm disable svc:/network/daytime:stream
3. daytime 서비스 비활성화 설정
 svcs -a |grep discard
 svcadm disable svc:/network/discard:dgram
 svcadm disable svc:/network/discard:stream
4. chargen 서비스 비활성화 설정
 svcs -a |grep chargen
 svcadm disable svc:/network/chargen:dgram
 svcadm disable svc:/network/chargen:stream" >> S1~73/Action.txt
fi

##########[S-24]NFS 서비스 비활성화##########

stat=$(inetadm | egrep -i "nfs|statd|lockd")

echo -e "\n##########[S-24]NFS 서비스 비활성화##########\n[NFS 관련 서비스 현황]\n$stat" >> S1~73/log/[S-24]log.txt
cat S1~73/log/[S-24]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep enable)" ];then
        echo -e "C|[S-24] NFS 관련 서비스가 활성화 상태입니다 - [취약]" >> S1~73/bad/[S-24]bad.txt
	cat S1~73/bad/[S-24]bad.txt >> S1~73/inspect.txt
	echo -e "[S-24]inetadm -d <중지시킬 서비스 이름> 명령으로 서비스 데몬 중지" >> S1~73/action/[S-24]action.txt
else
        echo -e "C|[S-24] NFS 관련 서비스가 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-24]good.txt
	cat S1~73/good/[S-24]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-24]action.txt" ];then
        echo -e "\n[(S-24)조치사항]
1. NFS 서비스 데몬 확인
 svcs -a | grep nfs
2. inetadm -d 명령으로 서비스 데몬 중지
 inetadm -d svc:/network/nfs/server:default" >> S1~73/Action.txt
fi

##########[S-26]automountd 제거##########

stat=$(svcs -a | grep autofs)

echo -e "\n##########[S-26]automountd 제거\n[automountd 서비스 현황]\n$stat" >> S1~73/log/[S-26]log.txt
cat S1~73/log/[S-26]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$(echo "$stat" | awk '{print$1}')" == "online" ];then
                echo -e "C|[S-26] autofs 서비스가 활성화 상태입니다 - [취약]" >> S1~73/bad/[S-26]bad.txt
		cat S1~73/bad/[S-26]bad.txt >> S1~73/inspect.txt
		echo -e "[S-26] inetadm -d <중지시킬 데몬> 명령으로 서비스 데몬 중지" >> S1~73/action/[S-26]action.txt
        else
                echo -e "C|[S-26] autofs 서비스가 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-26]good.txt
		cat S1~73/good/[S-26]good.txt >> S1~73/inspect.txt
        fi
else
        echo -e "C|[S-26] autofs 서비스가 존재하지 않습니다 - [양호]" >> S1~73/good/[S-26]good.txt
	cat S1~73/good/[S-26]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-26]action.txt" ];then
        echo -e "\n[(S-26)조치사항]
1. autofs 서비스 데몬 확인
 svcs -a | grep autofs
2. inetadm -d 명령으로 서비스 데몬 중지
 inetadm -d svc:/system/filesystem/autofs:default" >> S1~73/Action.txt
fi

##########[S-27]RPC 서비스 확인##########

stat=$(inetadm | grep rpc)

echo -e "\n##########[S-27]RPC 서비스 확인##########\n[RPC 서비스 현황]\n$stat" >> S1~73/log/[S-27]log.txt
cat S1~73/log/[S-27]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$(echo "$stat" | grep enabled | egrep "cmsd|ttdbserver|sadmind|rusers|wall|spray|rstart|nisd|rexd|pcnfsd|ypupdated|rquotad|kcms|cachefsd" | wc -l)" -ge 1 ];then
                echo -e "C|[S-27]불필요한 RPC 서비스가 활성화 상태입니다 - [취약]" >> S1~73/bad/[S-27]bad.txt
		cat S1~73/bad/[S-27]bad.txt >> S1~73/inspect.txt
		echo -e "[S-27] inetadm -d 명령으로 서비스 데몬 중지" >> S1~73/action/[S-27]action.txt
        else
                echo -e "C|[S-27]불필요한 RPC 서비스가 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-27]good.txt
		cat S1~73/good/[S-27]good.txt >> S1~73/inspect.txt
        fi
else
        echo -e "C|[S-27]RPC 서비스가 없습니다 - [양호]" >> S1~73/good/[S-27]good.txt
	cat S1~73/good/[S-27]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-27]action.txt" ];then
        echo -e "\n[(S-27)조치사항]
1. 실행중인 RPC 서비스 데몬 확인
 inetadm | grep rpc | grep enabled
2. 불필요한 RPC 서비스 데몬 중지
 inetadm -d <서비스 데몬 이름>" >> S1~73/Action.txt
fi

##########[S-28]NIS, NIS+ 점검##########

stat=$(svcs -a | grep -i "nis")

echo -e "\n##########[S-28]NIS, NIS+ 점검##########\n[NIS 서비스 사용 현황]\n$stat" >> S1~73/log/[S-28]log.txt
cat S1~73/log/[S-28]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep "enable")" ];then
        echo -e "C|[S-28]NIS 관련 서비스 데몬이 활성화 상태입니다 - [취약]" >> S1~73/bad/[S-28]bad.txt
	cat S1~73/bad/[S-28]bad.txt >> S1~73/inspect.txt
	echo -e "[S-28] inetadm -d 명령으로 NIS 서비스 중지" >> S1~73/action/[S-28]action.txt
else
        echo -e "C|[S-28]NIS 관련 서비스 데몬이 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-28]good.txt
	cat S1~73/good/[S-28]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-28]action.txt" ];then
        echo -e "\n[(S-28)조치사항]
1. NIS 관련 서비스 데몬 확인
 svcs -a | grep -i nis
2. inetadm -d 명령으로 서비스 데몬 중지
 inetadm -d <중지시킬 서비스 이름>" >> S1~73/Action.txt
fi


##########[S-29]tftp, talk 서비스 비활성화##########

stat=$(inetadm | egrep "tftp|talk")

echo -e "\n##########[S-29]tftp, talk 서비스 비활성화##########\n[talk, tftp 서비스 사용 여부]\n$stat" >> S1~73/log/[S-29]log.txt
cat S1~73/log/[S-29]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep -i "enable")" ];then
        echo -e "C|[S-29]tftp, talk 서비스 중 활성화 된 서비스가 존재합니다 - [취약]" >> S1~73/bad/[S-29]bad.txt
	cat S1~73/bad/[S-29]bad.txt >> S1~73/inspect.txt
	echo -e "[S-29] inetadm -d 명령으로 불필요한 서비스 중지" >> S1~73/action/[S-29]action.txt
else
        echo -e "C|[S-29]tftp, talk 서비스가 비활성화 상태입니다 - [양호]" >> S1~73/good/[S-29]good.txt
	cat S1~73/good/[S-29]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-29]action.txt" ];then
        echo -e "\n[(S-29)조치사항]
1. tftp, talk 서비스 데몬 확인
 svcs -a | egrep -i 'tftp|talk'
2. inetadm -d 명령으로 서비스 데몬 중지" >> S1~73/Action.txt
fi

:<<'END'

##########[S-30]Sendmail 버전 점검##########

stat=$(ps -ef | grep -v grep | grep sendmail)
ver=$(echo -e "ehlo localhost\nquit" | /usr/lib/sendmail -d0.4 -Am -bt 2>&1 | grep "Version" | awk '{print $NF}')

echo -e "\n##########[S-30]Sendmail 버전 점검##########\n[Sendmail 서비스 현황\n$stat\n[Sendmail 버전]\n$ver" >> S1~73/log/[S-30]log.txt
cat S1~73/log/[S-30]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | wc -l)" -ge 1 ];then
        echo -e "C|[S-30]Sendmail 서비스를 사용하고 있습니다. 최신버전인지 확인해주세요 - [취약]" >> S1~73/bad/[S-30]bad.txt
	cat S1~73/bad/[S-30]bad.txt >> S1~73/inspect.txt
	echo -e "[S-30] http://www.sendmail.org 또는 각 OS 벤더사의 보안 패치 설치" >> S1~73/action/[S-30]action.txt
else
        echo -e "[S-30]Sendmail 서비스를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-30]good.txt
	cat S1~73/good/[S-30]good.txt
fi

if [ -f "S1~73/action/[S-30]action.txt" ];then
        echo -e "\n[(S-30)조치사항]
http://www.sendmail.org 또는 각 OS 벤더사의 보안 패치 설치" >> S1~73/Action.txt
fi

END

##########[S-31]스팸 메일 릴레이 제한##########

stat=$(ps -ef | grep sendmail | grep -v grep)
stat2=$(cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied")

echo -e "\n##########[S-31]스팸 메일 릴레이 제한##########\n[Sendmail 서비스 현황\n$stat\n[릴레이 설정 현황]\n$stat2" >> S1~73/log/[S-31]log.txt
cat S1~73/log/[S-31]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$stat2" ];then
                if [ "$(echo "$stat2" | cut -c 1)" == "#" ];then
                        echo -e "C|[S-31]Sendmail 서비스를 사용 중이나 릴레이 방지 설정이 되지 않았습니다 - [취약]" >> S1~73/bad/[S-31]bad.txt
			cat S1~73/bad/[S-31]bad.txt
			echo -e "[S-31] vi 편집기를 이용하여  /etc/mail/sendmail.cf을 열어 R$* $#error $@ 5.7.1 $: '550 Relaying denied' 앞에 주석 제거" >> S1~73/action/[S-31]action.txt
                else
                        echo -e "C|[S-31]Sendmail 서비스를 사용 중이고, 릴레이 방지 설정이 되어 있습니다 - [양호]" >> S1~73/good/[S-31]good.txt
			cat S1~73/good/[S-31]good.txt >> S1~73/inspect.txt
                fi
        else
                echo -e "C|[S-31]Sendmail을 사용중이나 릴레이 방지 설정이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-31]bad.txt
		cat S1~73/bad/[S-31]bad.txt >> S1~73/inspect.txt
		echo -e "[S-31] vi 편집기를 이용하여 /etc/mail/sendmail.cf 파일을 열어 R$* $#error $@ 5.7.1 $: 550 Relaying denied' 추가" >> S1~73/action/[S-31]action.txt
        fi
else
        echo -e "C|[S-31]Sendmail 서비스를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-31]good.txt
	cat S1~73/good/[S-31]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-31]action.txt" ];then
        echo -e "\n[(S-31)조치사항]
vi 편집기를 이용하여  /etc/mail/sendmail.cf을 열어 R$* $#error $@ 5.7.1 $: '550 Relaying denied' 추가 또는 앞에 주석 제거" >> S1~73/Action.txt
fi

##########[S-32]일반 사용자의 Sendmail 실행 방지##########

stat=$(ps -ef | grep sendmail | grep -v grep)
stat2=$(cat /etc/mail/sendmail.cf | grep -v '^ *#' | grep PrivacyOptions)

echo -e "\n##########[S-32]일반 사용자의 Sendmail 실행 방지##########\n[Sendmail 서비스 현황]\n$stat\n[실행 방지 설정 현황]\n$stat2" >> S1~73/log/[S-32]log.txt
cat S1~73/log/[S-32]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | wc -l)" -ge 1 ];then
        if [ "$(echo "$stat2" | grep restrictqrun)" ];then
                echo -e "C|[S-32]SMTP 서비스를 사용 중이나, Sendmail 실행 방지가 설정되어 있습니다 - [양호]" >> S1~73/good/[S-32]good.txt
		cat S1~73/good/[S-32]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-32]SMTP 서비스를 사용 중이나, Sendmail 실행 방지가 설정되지 않았습니다 - [취약]" >> S1~73/bad/[S-32]bad.txt
		cat S1~73/bad/[S-32]bad.txt >> S1~73/inspect.txt
		echo -e "[S-32] vi 편집기를 이용하여 /etc/mail/sendmail.cf 파일을 열어 PrivacyOptions 뒤에 restrictqrun 추가" >> S1~73/action/[S-32]action.txt
        fi
else
        echo -e "C|[S-32]SMTP 서비스를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-32]good.txt
	cat S1~73/good/[S-32]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-32]action.txt" ];then
        echo -e "\n[(S-32)조치사항]
vi 편집기를 이용하여 /etc/mail/sendmail.cf 파일을 열어 PrivacyOptions 뒤에 restrictqrun 추가" >> S1~73/Action.txt
fi

##########[S-33]DNS 보안 버전 패치##########

stat=`named -v`

echo -e "\n##########[S-33]DNS 보안 버전 패치##########\n[DNS 버전]\n$stat" >> S1~73/log/[S-33]log.txt
cat S1~73/log/[S-33]log.txt >> S1~73/log.txt

##########[S-34]DNS Zone Transfer 설정##########

stat=$(svcs -a | grep dns)
stat2=$(named -v | cut -c 6)

echo -e "\n##########[S-34]DNS Zone Transfer 설정##########\n[DNS 사용여부]\n$stat\n\n[BIND 버전]\n`named -v`" >> S1~73/log/[S-34]log.txt
cat S1~73/log/[S-34]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | egrep "online|enable")" ];then
        if [ "$(echo "$stat2")" -lt 8 ];then
                chk=`cat /etc/named.conf 2>/dev/null | grep "xfrnets"`
                if [ "$chk" ];then
                        echo -e "C|[S-34]Zone Transfer를 허가된 사용자에게만 허>용했습니다 - [양호]" >> S1~73/good/[S-34]good.txt
			cat S1~73/good/[S-34]good.txt >> S1~73/inspect.txt
                else
                        echo -e "C|[S-34]Zone Transfer를 모든 사용자에게 허용했>습니다 - [취약]" >> S1~73/bad/[S-34]bad.txt
			cat S1~73/bad/[S-34]bad.txt >> S1~73/inspect.txt
			echo -e "[S-34] vi 편집기를 이용하여 /etc/named.conf 파일을 열어 Options { }; 사이에 xfrnets 허용하고자 하는 IP; 추가" >> S1~73/action/[S-34]action.txt
                fi
        else
                chk2=`cat /etc/named.conf 2>/dev/null | grep "allow-transfer"`
                if [ "$chk2" ];then
                        echo -e "C|[S-34]Zone Transfer를 허가된 사용자에게만 허>용했습니다 - [양호]" >> S1~73/good/[S-34]good.txt
			cat S1~73/good/[S-34]good.txt
                else
                        echo -e "C|[S-34]Zone Transfer를 모든 사용자에게 허용했>습니다 - [취약]" >> S1~73/bad/[S-34]bad.txt
			cat S1~73/bad/[S-34]bad.txt >> S1~73/inspect.txt
			echo -e "[S-34] vi 편집기를 이용하여 /etc/named.conf 파일을 열어 Options { }; 사이에 xfrnets 허용하고자 하는 IP; 추가" >> S1~73/action/[S-34]action.txt
                fi
        fi
else
        echo -e "C|[S-34]DNS 서비스를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-34]good.txt
	cat S1~73/good/[S-34]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-34]action.txt" ];then
        echo -e "\n[(S-34)조치사항]
1. DNS 서비스 불필요 시 중지
 svcadm disable svc:/network/dns/server:default
2. 필요 시 허용 할 IP 설정
BIND8
Options {
 allow-transfer (존 파일 전송을 허용하고자 하는 IP;);
};

BIN4.9
Options
 xfrnets 허용하고자 하는 IP" >> S1~73/Action.txt
fi

##########[S-35]웹 서비스 디렉토리 리스팅 제거##########

stat=$(cat /etc/apache2/2.4/httpd.conf | grep Indexes | grep -v '^ *#')

echo -e "\n##########[S-35]웹 서비스 디렉토리 리스팅 제거##########\n[디렉토리 검색 기능 현황]\n$stat" >> S1~73/log/[S-35]log.txt
cat S1~73/log/[S-35]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep -v "-")" ];then
        echo -e "C|[S-35]디렉토리 검색 기능을 사용 중 입니다 - [취약]" >> S1~73/bad/[S-35]bad.txt
	cat S1~73/bad/[S-35]bad.txt >> S1~73/inspect.txt
	echo -e "[S-35] vi 편집기를 이용하여 /etc/apache2/2.4/httpd.conf 파일을 열어 모든 디렉토리의 Option 지시자에서 Indexes 옵션 제거" >> S1~73/action/[S-35]action.txt
else
        echo -e "C|[S-35]디렉토리 검색 기능을 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-35]good.txt
	cat S1~73/good/[S-35]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-35]action.txt" ];then
        echo -e "\n[(S-35)조치사항]
1. vi 편집기를 이용하여 /etc/apache2/2.4/httpd.conf 파일을 열어 모든 디렉토리의 Option 지시자에서 Indexes 옵션 제거
<Directory />
 Options Indexes 삭제 (또는 -Indexes)
 AllowOverride None
 Order allow, deny
 Allow from all
</Directory>" >> S1~73/Action.txt
fi

##########[S-37]웹 서비스 상위 디렉토리 접근 금지##########

stat=$(cat /etc/apache2/2.4/httpd.conf | grep AllowOverride | grep -v '^ *#')

echo -e "\n##########[S-37]웹 서비스 상위 디렉토리 접근 금지##########\n[상위 디렉토리 접근 설정 현황]\n$stat" >> S1~73/log/[S-37]log.txt
cat S1~73/log/[S-37]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep None)" ];then
        echo -e "C|[S-37]디렉토리 별 설정 값 중 상위 디렉토리에 접근 가능하도록 설정된 디렉토리가 있습니다 - [취약]" >> S1~73/bad/[S-37]bad.txt
	cat S1~73/bad/[S-37]bad.txt >> S1~73/inspect.txt
	echo -e "[S-37] vi 편집기를 이용하여 /etc/apache2/2.4/httpd.conf 파일을 열어 AllowOverride 지시자 옵션을 AuthConfig로 수정" >> S1~73/action/[S-37]action.txt
else
        echo -e "C|[S-37]모든 디렉토리 설정에 상위 디렉토리로 이동 제한이 설정되었습니다 - [양호]" >> S1~73/good/[S-37]good.txt
	cat S1-73/good/[S-37]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-37]action.txt" ];then
        echo -e "\n[(S-37)조치사항]
1. vi 편집기를 이용하여 /[Apache_home]/conf/httpd.conf 파일 열기
2. 설정된 모든 디렉토리의 AllowOverride 지시자에서 AuthConfig 옵션 설정
 AllowOverride AuthConfig
3. 사용자 인증을 설정할 디렉토리에 .htaaccess 파일 생성

 AuthName '디렉터리 사용자 인'증
 AuthType Basic
 AuthUserFile /usr/local/apache/test/.auth
 Require valid-user" >> S1~73/Action.txt
fi

##########[S-38]웹 서비스 불필요한 파일 제거##########

stat=$(find /etc/apache2/2.4 -name manual)

echo -e "\n##########[S-38]웹 서비스 불필요한 파일 제거##########\n[manual 파일 존재여부]\n$stat" >> S1~73/log/[S-38]log.txt
cat S1~73/log/[S-38]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        echo -e "C|[S-38]불필요한 파일이 존재합니다 - [취약]" >> S1~73/bad/[S-38]bad.txt
	cat S1~73/bad/[S-38]bad.txt >> S1~73/inspect.txt
	echo -e "[S-38] rm -rf 명령으로 불필요한 파일 및 디렉토리를 제거" >> S1~73/action/[S-38]action.txt
else
        echo -e "C|[S-38]불필요한 파일이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-38]good.txt
	cat S1~73/good/[S-38]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-38]action.txt" ];then
        echo -e "\n[(S-38)조치사항]
1. ls 명령으로 확인된 매뉴얼 디렉토리 및 파일 제거
 rm -rf /[Apache_home]/htdocs/manual
 rm -rf /[Apache_home]/manual
2. ls 명령어로 정상적인 제거 확인
 ls -ld/[Apache_home]/htdocs/manual
 ls -ld/[Apache_home]/manual" >> S1~73/Action.txt
fi

##########[S-39]웹 서비스 링크 사용 금지##########

stat=$(cat /etc/apache2/2.4/httpd.conf | grep FollowSymLinks | grep -v '^ *#')

echo -e "\n##########[S-39]웹 서비스 링크 사용 금지##########\n[심볼릭 링크 설정 현황]\n$stat" >> S1~73/log/[S-39]log.txt
cat S1~73/log/[S-39]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep -v "-")" ];then
        echo -e "C|[S-39]심볼릭 링크, aliases 사용을 제한하지 않았습니다 - [취약]" >> S1~73/bad/[S-39]bad.txt
	cat S1~73/bad/[S-39]bad.txt >> S1~73/inspect.txt
	echo -e "[S-39] vi 편집기를 이용하여 /[Apache_home]/conf/[httpd.conf] 파일을 열어 모든 디렉토리의 Options 지시자에서 FollowSymLinks 옵션 제거" >> S1~73/action/[S-39]action.txt
else
        echo -e "C|[S-39]심볼릭 링크, aliases 사용을 제한하였습니다 - [양호]" >> S1~73/good/[S-39]good.txt
	cat S1~73/good/[S-39]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-39]action.txt" ];then
        echo -e "\n[(S-39)조치사항]
1. vi 편집기를 이용하여 /[Apache_home]/conf/httpd.conf 파일 열기
2. 설정된 모든 디렉토리의 Options 지시자에서 FollowSymLinks 옵션 제거
 Options FollowSymLinks 삭제 또는 -FollowSymLinks로 수정" >> S1~73/Action.txt
fi

##########[S-40]웹 서비스 파일 업로드 및 다운로드 제한##########

stat=$(cat /etc/apache2/2.4/httpd.conf | grep LimitRequestBody)

echo -e "\n##########[S-40]웹 서비스 파일 업로드 및 다운로드 제한##########\n[파일 제한 설정 현황]\n$stat" >> S1~73/log/[S-40]log.txt
cat S1~73/log/[S-40]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        echo -e "C|[S-40]파일 업로드 및 다운로드를 제한하였습니다 - [양호]" >> S1~73/good/[S-40]good.txt
	cat S1~73/good/[S-40]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-40]파일 업로드 및 다운로드를 제한하지 않았습니다 - [취약]" >> S1~73/bad/[S-40]bad.txt
	cat S1~73/bad/[S-40]bad.txt >> S1~73/inspect.txt
	echo -e "[S-40] vi 편집기를 이용하여 /[Apache_home]/conf/httpd.conf 파일을 열어 모든 디렉토리의 LimitRequestBody 지시자에서 파일 사이즈 용량 제한(5M)" >> S1~73/action/[S-40]action.txt
fi

if [ -f "S1~73/action/[S-40]action.txt" ];then
        echo -e "\n[(S-40)조치사항]
1. vi 편집기를 이용하여 /[Apache_home]/conf/httpd.conf 파일 열기
2. 설정된 모든 디렉터리의 LimitRequestBody 지시자에서 파일 사이즈 용량 제한 설정
 LimitRequestBody 5000000" >> S1~73/Action.txt
fi

##########[S-41]웹 서비스 영역의 분리##########

stat=$(cat /etc/apache2/2.4/httpd.conf | grep DocumentRoot | grep -v '^ *#')

echo -e "\n##########[S-41]웹 서비스 영역의 분리##########\n[DocumentRoot 경로]\n$stat" >> S1~73/log/[S-41]log.txt
cat S1~73/log/[S-41]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | egrep "/usr/local/apache*|/var/www/html")" ];then
        echo -e "C|[S-41]DocumentRoot를 기본 디렉토리로 지정하였습니다 - [취약]" >> S1~73/bad/[S-41]bad.txt
	cat S1~73/bad/[S-41]bad.txt >> S1~73/inspect.txt
	echo -e "[S-41] vi 편집기를 이용하여 /[Apache_home]/conf/httpd.conf 파일 열어 DocumentRoot 설정 부분에 '/usr/local/apache/htdocs', '/usr/local/apache2/htdocs', 'var/www/html' 셋 중 하나가 아닌 별도의 디렉토리로 변경" >> S1~73/action/[S-41]action.txt
else
        echo -e "C|[S-41]DocumentRoot를 별도의 디렉토리로 지정하였습니다 - [양호]" >> S1~73/good/[S-41]good.txt
	cat S1~73/good/[S-41]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-41]action.txt" ];then
        echo -e "\n[(S-41)조치사항]
1. vi 편집기를 이용하여 /[Apache_home]/conf/httpd.conf 파일 열기
2. DocumentRoot 설정 부분에 '/usr/local/apache/htdocs', '/usr/local/apache2/htdocs', '/var/www/html' 셋 중 하나가 아닌 별도의 디렉터리로 변경" >> S1~73/Action.txt
fi

##########[S-44]root 이외의 UID '0'금지##########

stat=$(cat /etc/passwd | awk -F":" '{print$1, $3}')

echo -e "\n##########[S-44]root 이외의 UID '0' 금지##########\n[사용자명/UID 현황]\n$stat" >> S1~73/log/[S-44]log.txt
cat S1~73/log/[S-44]log.txt >> S1~73/log.txt

chk=$(cat /etc/passwd | awk -F":" '{print$3}' | grep -w "0" | wc -l)
if [ "$chk" -eq 1 ];then
        echo -e "A|[S-44]root 계정과 동일한 UID를 갖는 계정이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-44]good.txt
	cat S1~73/good/[S-44]good.txt >> S1~73/inspect.txt
else
        echo -e "A|[S-44]root 계정과 동일한 UID를 갖는 계정이 존재합니다 - [취약]" >> S1~73/bad/[S-44]bad.txt
	cat S1~73/bad/[S-44]bad.txt >> S1~73/inspect.txt
	echo -e "[S-44] /etc/passwd 파일을 보고 usermod 명령으로 UID가 0인 일반 계정의 UID를 100 이상으로 수정" >> S1~73/action/[S-44]action.txt
fi

if [ -f "S1~73/action/[S-44]action.txt" ];then
        echo -e "\n[(S-44)조치사항]
1. cat /etc/passwd 명령으로 파일 내 root를 제외한 일반 계정의 UID가 0인지 확인
2. usermod 명령으로 UID가 0인 일반 계정의 UID를 100 이상으로 수정
 usermod -u 100 '바꿀 계정 이름'" >> S1~73/Action.txt
fi

##########[S-45]root 계정 su 제한##########

stat=$(cat /etc/group | grep wheel)

echo -e "\n##########[S-45]root 계정 su 제한##########\n[wheel 그룹 현황]\n$stat" >> S1~73/log/[S-45]log.txt
cat S1~73/log/[S-45]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | awk -F":" '{print$4}')" ];then
        echo -e "A|[S-45]su 명령어를 모든 사용자가 사용하도록 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-45]bad.txt
	cat S1~73/bad/[S-45]bad.txt >> S1~73/inspect.txt
	echo -e "[S-45] wheel 그룹이 존재하지 않는 경우 groupadd 명령으로 wheel 그룹을 만들고, chgrp wheel /usr/bin/su 명령으로 su 명령어 그룹을 변경 및 사용 권한을 4750으로 설정하고 wheel 그룹에 su 명령 허용 계정을 등록" >> S1~73/action/[S-45]action.txt
else
        echo -e "A|[S-45]su 명령어를 특정 그룹에 속한 사용자만 사용하도록 설정되어 있습니다 - [양호]" >> S1~73/good/[S-45]good.txt
	cat S1~73/good/[S-45]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-45]action.txt" ];then
        echo -e "\n[(S-45)조치사항]
1. wheel group 생성 (wheel 그룹이 존재하지 않는 경우)
 groupadd wheel
2. su 명령어 그룹 변경
 chgrp wheel /usr/bin/su
3. su 명령어 사용권한 변경
 chmod 4750 /usr/bin/su
4. wheel 그룹에 su 명령 허용 계정 등록
 usermod –G wheel <user_name>
 또는, 직접 /etc/group 파일을 수정하여 필요한 계정 등록
 wheel:x:10: -> wheel:x:10:root,admin" >> S1~73/Action.txt
fi

##########[S-46]패스워드 최소 길이 설정##########

stat=$(cat /etc/default/passwd | grep -i "PASSLENGTH=")

echo -e "\n##########[S-46]패스워드 최소 길이 설정##########\n[패스워드 최소 길이 현황]\n$stat" >> S1~73/log/[S-46]log.txt
cat S1~73/log/[S-46]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep -v "#")" ];then
        if [ "$(echo "$stat" | awk -F"=" '{print$2}')" -ge 8 ];then
                echo -e "A|[S-46]패스워드 최소 길이가 권장설정만큼 설정되어 있습니다 - [양호]" >> S1~73/good/[S-46]good.txt
		cat S1~73/good/[S-46]good.txt >> S1~73/inspect.txt
        else
                echo -e "A|[S-46]패스워드 최소 길이가 권장설정보다 낮습니다 - [취약]" >> S1~73/bad/[S-46]bad.txt
		cat S1~73/bad/[S-46]bad.txt >> S1~73/inspect.txt
		echo -e "[S-46] vi 편집기를 이용하여 /etc/default/passwd 파일을 열어 PASSLENGTH의 설정값을 8이상으로 설정" >> S1~73/action/[S-46]action.txt
        fi
else
        echo -e "A|[S-46]패스워드 최소 길이 설정값이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-46]bad.txt
	cat S1~73/bad/[S-46]bad.txt >> S1~73/inspect.txt
	echo -e "[S-46] vi 편집기를 이용하여 /etc/default/passwd 파일을 열어 PASSLENGTH의 설정값을 8이상으로 설정 및 앞에 주석 제거" >> S1~73/action/[S-46]action.txt
fi

if [ -f "S1~73/action/[S-46]action.txt" ];then
        echo -e "\n[(S-46)조치사항]
1. vi 편집기를 이용하여 /etc/default/passwd 파일 열기
2. PASSLENGTH=의 값을 8이상으로 설정 및 앞에 주석 제거" >> S1~73/Action.txt
fi

##########[S-47]패스워드 최대 사용기간 설정##########

stat=$(cat /etc/default/passwd | grep -i "MAXWEEKS=")

echo -e "\n##########[S-47]패스워드 최대 사용기간 설정##########\n[패스워드 최대 사용기간 현황]\n$stat" >> S1~73/log/[S-47]log.txt
cat S1~73/log/[S-47]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep -v "#")" ];then
        if [ "$(echo "$stat" | awk -F"=" '{print$2}')" -le 12 ];then
                echo -e "A|[S-47]패스워드 최대 사용기간이 권장설정만큼 설정되어 있습니다 - [양호]" >> S1~73/good/[S-47]good.txt
		cat S1~73/good/[S-47]good.txt >> S1~73/inspect.txt
        else
                echo -e "A|[S-47]패스워드 최대 사용기간이 권장설정보다 높습니다 - [취약]" >> S1~73/bad/[S-47]bad.txt
		cat S1~73/bad/[S-47]bad.txt >> S1~73/inspect.txt
		echo -e "[S-47] vi 편집기를 이용하여 /etc/default/passwd 파일을 열어 MAXWEEKS의 설정값을 12 이하로 설정" >> S1~73/action/[S-47]action.txt
        fi
else
        echo -e "A|[S-47]패스워드 최대 사용기간 설정값이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-47]bad.txt
	cat S1~73/bad/[S-47]bad.txt >> S1~73/inspect.txt
	echo -e "[S-47] vi 편집기를 이용하여 /etc/default/passwd 파일을 열어 MAXWEEKS의 설정값을 12이하로 설정 및 앞에 주석 제거" >> S1~73/action/[S-47]action.txt
fi

if [ -f "S1~73/action/[S-47]action.txt" ];then
        echo -e "\n[(S-47)조치사항]
1. vi 편집기를 이용하여 /etc/default/passwd 파일 열기
2. MAXWEEKS= 값을 12 이하로 설정 및 앞에 주석 제거" >> S1~73/Action.txt
fi

##########[S-48]패스워드 최소 사용기간 설정##########

stat=$(cat /etc/default/passwd | grep -i "MINWEEKS=")

echo -e "\n##########[S-48]패스워드 최소 사용기간 설정##########\n[패스워드 최소 사용기간 현황]\n$stat" >> S1~73/log/[S-48]log.txt
cat S1~73/log/[S-48]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep -v "#")" ];then
        if [ "$(echo "$stat" | awk -F"=" '{print$2}')" -ge 1 ];then
                echo -e "A|[S-48]패스워드 최소 사용기간이 권장 값입니다 - [양호]" >> S1~73/good/[S-48]good.txt
		cat S1~73/good/[S-48]good.txt >> S1~73/inspect.txt
        else
                echo -e "A|[S-48]패스워드 최소 사용기간 값이 설정되지 않았습니다 - [취약]" >> S1~73/bad/[S-48]bad.txt
		cat S1~73/bad/[S-48]bad.txt >> S1~73/inspect.txt
		echo -e "[S-48] vi 편집기를 이용하여 /etc/default/passwd 파일을 열어 MINWEEKS 설정 값을 1 이상으로 설정" >> S1~73/action/[S-48]action.txt
        fi
else
        echo -e "A|[S-48]패스워드 최소 사용기간 설정값이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-48]bad.txt
	cat S1~73/bad/[S-48]bad.txt >> S1~73/inspect.txt
	echo -e "[S-48] vi 편집기를 이용하여 /etc/default/passwd 파일을 열어 MINWEEKS 앞에 주석 제거" >> S1~73/action/[S-48]action.txt
fi

if [ -f "S1~73/action/[S-48]action.txt" ];then
        echo -e "\n[(S-48)조치사항]
1. vi 편집기를 이용하여 /etc/default/passwd 파일 열기
2. MINWEEKS 앞에 주석 제거 및 설정 값 1 이상으로 설정" >> S1~73/Action.txt
fi

##########[S-49]불필요한 계정 제거##########

stat=$(cat /etc/passwd)

echo -e "\n##########[S-49]불필요한 계정 제거##########\n[/etc/passwd 계정 현황]\n$stat" >> S1~73/log/[S-49]log.txt
cat S1~73/log/[S-49]log.txt >> S1~73/log.txt
echo -e "A|[S-49] 불필요한 계정이 존재하는지 점검 필요 - [점검]" >> S1~73/bad/[S-49]bad.txt
cat S1~73/bad/[S-49]bad.txt >> S1~73/inspect.txt
echo -e "[S-49] cat /etc/passwd 명령으로 미사용 계정 및 의심스러운 계정 존재 여부를 확인하고 있다면 제거" >> S1~73/action/[S-49]action.txt
if [ -f "S1~73/action/[S-49]action.txt" ];then
        echo -e "\n[(S-49)조치사항]
1. cat /etc/passwd 명령으로 미사용 계정 및 의심스러운 계정 존재 여부 확인
2. 불필요한 계정이 존재할 시 userdel <user_name> 명령으로 제거" >> S1~73/Action.txt
fi

##########[S-50]관리자 그룹에 최소한의 계정 포함##########

stat=$(cat /etc/group | awk -F":" '$1 == "root" {print}')

echo -e "\n##########[S-50]관리자 그룹에 최소한의 계정 포함##########\n[/etc/group 그룹 현황]\n$stat" >> S1~73/log/[S-50]log.txt
cat S1~73/log/[S-50]log.txt >> S1~73/log.txt
echo -e "A|[S-50] 관리자 그룹에 불필요한 계정이 등록되어 있는지 점검 필요 - [점검]" >> S1~73/bad/[S-50]bad.txt
cat S1~73/bad/[S-50]bad.txt >> S1~73/inspect.txt
echo -e "[S-50] cat /etc/group 명령으로 불필요한 계정이 관리자 그룹에 등록되어 있는지 확인하고 있다면 제거" >> S1~73/action/[S-50]action.txt
if [ -f "S1~73/action/[S-50]action.txt" ];then
        echo -e "\n[(S-50)조치사항]
1. vi 편집기를 이용하여 /etc/group 파일 열기
2. root 그룹에 등록된 불필요한 계정 제거" >> S1~73/Action.txt
fi

##########[S-51]계정이 존재하지 않는 GID 금지##########

stat=$(cat /etc/group)
stat2=$(cat /etc/passwd)

echo -e "\n##########[S-51]계정이 존재하지 않는 GID 금지##########\n[그룹 현황]\n$stat\n[계정 현황]\n$stat2" >> S1~73/log/[S-51]log.txt
cat S1~73/log/[S-51]log.txt >> S1~73/log.txt
echo -e "A|[S-51] 시스템 관리나 운용에 불필요한 그룹이 존재하는지 점검 필요 - [점검]" >> S1~73/bad/[S-51]bad.txt
cat S1~73/bad/[S-51]bad.txt >> S1~73/inspect.txt
echo -e "[S-51] cat /etc/group 명령으로 시스템 관리나 운용에 불필요한 그룹이 있는지 확인 후 있다면 제거" >> S1~73/action/[S-51]action.txt
if [ -f "S1~73/action/[S-51]action.txt" ];then
        echo -e "\n[(S-51)조치사항]
1. cat /etc/group 명령으로 시스템 관리나 운용에 불필요한 그룹이 존재하는지 확인
2. groupdel <group_name> 명령으로 불필요한 그룹 제거" >> S1~73/Action.txt
fi

##########[S-52]동일한 UID 금지##########

stat=$(cat /etc/passwd)

echo -e "\n##########[S-52]동일한 UID 금지##########\n[/etc/passwd 현황]\n$stat" >> S1~73/log/[S-52]log.txt
cat S1~73/log/[S-52]log.txt >> S1~73/log.txt

if [ "$(cat /etc/passwd | awk -F":" '{print $3}' | uniq -d | while read result_UID; do grep ":$result_UID:" /etc/passwd; done)" ];then
        echo -e "A|[S-52]중복된 UID가 존재합니다 - [취약]" >> S1~73/bad/[S-52]bad.txt
	cat S1~73/bad/[S-52]bad.txt >> S1~73/inspect.txt
	echo -e "[S-52] usermod 명령으로 동일한 UID로 설정된 사용자 계정의 UID 변경" >> S1~73/action/[S-52]action.txt
else
        echo -e "A|[S-52]중복된 UID가 존재하지 않습니다 - [양호]" >> S1~73/good/[S-52]good.txt
	cat S1~73/good/[S-52]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-52]action.txt" ];then
        echo -e "\n[(S-52)조치사항]
1. cat /etc/passwd 명령으로 동일한 UID로 설정된 사용자 계정이 존재하는지 확인
2. 존재하는 경우 usermod -u <변경할 UID 값> <user_name> 명령으로 UID 변경" >> S1~73/Action.txt
fi

##########[S-53]사용자 shell 점검##########

stat=$(awk -F":" '$1 ~ /^(daemon|bin|sys|adm|listen|nobody|nobody4|noaccess|diag|listen|operator|games|gopher)$/ {print;}' /etc/passwd)
NNID=$(echo "daemon\nbin\nsys\nadm\nlisten\nnobody\nnobody4\nnoaccess\ndiag\nlisten\noperator\ngames\ngopher")

echo -e "\n##########[S-53]사용자 shell 점검##########\n[주요 계정 현황]\n$stat\n\n[불필요한 계정 리스트]\n$NNID" >> S1~73/log/[S-53]log.txt
cat S1~73/log/[S-53]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | egrep -v "false|nologin")" ];then
        echo -e "A|[S-53]로그인이 필요하지 않은 계정에 /bin/false 또는 /sbin/nologin 쉘이 부여되지 않았습니다 - [취약]" >> S1~73/bad/[S-53]bad.txt
	cat S1~73/bad/[S-53]bad.txt >> S1~73/inspect.txt
	echo -e "[S-53] 로그인이 필요하지 않는 계정에 /bin/false(/sbin/nologin) 부여 및 변경" >> S1~73/action/[S-53]action.txt
else
        echo -e "A|[S-53]로그인이 필요하지 않은 계정에 /bin/false 또는 /sbin/nologin 쉘이 부여되었습니다 - [양호]" >> S1~73/good/[S-53]good.txt
	cat S1~73/good/[S-53]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-53]action.txt" ];then
        echo -e "\n[(S-53)조치사항]
1. vi 편집기를 이용하여 /etc/passwd 파일 열기
2. 로그인 쉘 부분인 계정 맨 마지막에 /bin/false 또는 /sbin/nologin 부여 및 변경" >> S1~73/Action.txt
fi

##########[S-54]Session Timeout 설정##########

stat=$(cat /etc/profile | grep -i "TMOUT=")

echo -e "\n##########[S-54]Session Timeout 설정##########\n[Session Timeout 설정 현황]\n$stat" >> S1~73/log/[S-54]log.txt
cat S1~73/log/[S-54]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$(echo "$stat" | awk -F"=" '[print$2}')" -le 600 ];then
                echo -e "A|[S-54]Session Timeout이 600초 이하로 설정되었습니다 - [양호]" >> S1~73/good/[S-54]good.txt
		cat S1~73/good/[S-54]good.txt >> S1~73/inspect.txt
        else
                echo -e "A|[S-54]Session Timeout이 600초 이하로 설정되지 않았습니다 - [취약]" >> S1~73/bad/[S-54]bad.txt
		cat S1~73/bad/[S-54]bad.txt >> S1~73/inspect.txt
		echo -e "[S-54] vi 편집기를 이용하여 /etc/profile 파일을 열어 
TMOUT=600
export TMOUT 추가" >> S1~73/action/[S-54]action.txt
        fi
else
        echo -e "A|[S-54]Session Timeout 관련 설정값이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-54]bad.txt
	cat S1~73/bad/[S-54]bad.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-54]action.txt" ];then
        echo -e "\n[(S-54)조치사항]
1. vi 편집기를 이용하여 /etc/profile 파일 열기
2. 아래와 같이 수정 또는 추가
TMOUT=600(10분 이하)
export TMOUT" >> S1~73/Action.txt
fi

##########[S-55]hosts.lpd 파일 소유자 및 권한 설정##########

stat=$(ls -l /etc | grep "hosts.lpd")
chk=$(stat -c %a /etc/hosts.lpd 2>/dev/null)
chk2=$(echo "$stat" | awk '{print$3}')

echo -e "\n##########[S-55]hosts.lpd 파일 소유자 및 권한 설정##########\nhosts.lpd 파일 소유자 : $chk2\nhosts.lpd 파일 권한 : $chk" >> S1~73/log/[S-55]log.txt
cat S1~73/log/[S-55]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$chk" -eq 600 ];then
                echo -e "B|[S-55]hosts.lpd 파일이 존재하지만 권한이 600으로 설정되어 있습니다 - [양호]" >> S1~73/good/[S-55]good.txt
		cat S1~73/good/[S-55]good.txt >> S1~73/inspect.txt
        else
                echo -e "B|[S-55]hosts.lpd 파일이 존재하지만 권한이 600으로 설정되어 있지 않습니다 - [취약]" >> S1~73/bad/[S-55]bad.txt
		cat S1~73/bad/[S-55]bad.txt >> S1~73/inspect.txt
		echo -e "[S-55] hosts.lpd 파일을 삭제하거나 필요 시 파일의 권한을 600, 소유자를 root 로 설정" >> S1~73/action/[S-55]action.txt
        fi
else
        echo -e "B|[S-55]hosts.lpd 파일이 존재하지 않습니다 - [양호]" >> S1~73/good/[S-55]good.txt
	cat S1~73/good/[S-55]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-55]action.txt" ];then
        echo -e "\n[(S-55)조치사항]
1. hosts.lpd 파일 삭제
 rm -rf /etc/hosts.lpd
2. 필요 시 파일의 권한을 600, 소유자를 root로 설정
 chmod 600 /etc/hosts.lpd
 chown root /etc/hosts.lpd" >> S1~73/Action.txt
fi

##########[S-56]UMASK 설정 관리##########

stat=$(cat /etc/profile | grep UMASK)

echo -e "\n##########[S-56]UMASK 설정 관리##########\n[UMASK 현황]\n$stat" >> S1~73/log/[S-56]log.txt
cat S1~73/log/[S-56]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$(echo "$stat" | cut -c 1)" == "#" ];then
                echo -e "B|[S-56]UMASK 설정이 주석처리 되었습니다 - [취약]" >> S1~73/bad/[S-56]bad.txt
		cat S1~73/bad/[S-56]bad.txt >> S1~73/inspect.txt
		echo -e "[S-56] vi 편집기를 이용하여 /etc/profile 파일을 열어 UMASK 앞에 주석 제거" >> S1~73/action/[S-56]action.txt
        else
                if [ "$(echo "stat" | awk -F"=" '{print$2}')" -ge 022 ];then
                        echo -e "B|[S-56]UMASK 설정 값이 022 이상입니다 - [양호]" >> S1~73/good/[S-56]good.txt
			cat S1~73/good/[S-56]good.txt >> S1~73/inspect.txt
                else
                        echo -e "B|[S-56]UMASK 설정 값이 022 미만입니다 - [취약]" >> S1~73/bad/[S-56]bad.txt
			cat S1~73/bad/[S-56]bad.txt >> S1~73/inspect.txt
			echo -e "[S-56] vi 편집기를 이용하여 /etc/profile 파일을 열어 다음과 같이 설정
umask 022
export umask" >> S1~73/action/[S-56]action.txt
                fi
        fi
else
        echo -e "B|[S-56]UMASK 설정 값이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-56]bad.txt
	cat S1~73/bad/[S-56]bad.txt >> S1~73/inspect.txt
	echo -e "[S-56] vi 편집기를 이용하여 /etc/profile 파일을 열어 다음과 같이 설정
umask 022
export umask" >> S1~73/action/[S-56]action.txt
fi

if [ -f "S1~73/action/[S-56]action.txt" ];then
        echo -e "\n[(S-56)조치사항]
1. vi 편집기를 이용하여 /etc/profile 파일 열기
2. 아래와 같이 수정 또는 신규 삽입
 umask 022
 export umask" >> S1~73/Action.txt
fi

##########[S-57]홈 디렉토리 소유자 및 권한 설정##########

stat=$(cat /etc/passwd)

echo -e "\n##########[S-57]홈 디렉토리 소유자 및 권한 설정##########\n[/etc/passwd 현황]\n$stat" >> S1~73/log/[S-57]log.txt
cat S1~73/log/[S-57]log.txt >> S1~73/log.txt
echo -e "B|[S-57] /etc/passwd 파일에서 사용자별 홈 디렉토리 확인 후 소유자 및 권한 확인 필요 - [점검]" >> S1~73/bad/[S-57]bad.txt
cat S1~73/bad/[S-57]bad.txt >> S1~73/inspect.txt
echo -e "[S-57] /etc/passwd 파일을 연 후 파일 내 존재하는 모든 사용자 계정이 적절한 홈 디렉토리를 갖는지 확인하고, 아닐경우 디렉토리의 소유자 및 권한 변경
 chown <user_name> <user_home_directory>
 chmod o-w <user_home_directory>" >> S1~73/action/[S-57]action.txt
if [ -f "S1~73/action/[S-57]action.txt" ];then
        echo -e "\n[(S-57)조치사항]
1. cat /etc/passwd 명령으로 사용자별 홈 디렉토리 확인 후 소유자 및 권한 확인
 cat /etc/passwd
 ls -ald <user_home_directory>
2. 홈 디렉토리의 소유자 및 권한 변경
 chown <user_name> <user_home_directory>
 chmod o-w <user_home_directory>" >> S1~73/Action.txt
fi 

##########[S-58]홈 디렉토리로 지정한 디렉토리의 존재 관리##########

stat=$(cat /etc/passwd)

echo -e "\n##########[S-58]홈 디렉토리로 지정한 디렉토리의 존재 관리##########\n[/etc/passwd 현황]\n$stat" >> S1~73/log/[S-58]log.txt
cat S1~73/log/[S-58]log.txt >> S1~73/log.txt
echo -e "B|[S-58] 홈 디렉토리가 존재하지 않는 계정이 있는지 점검 필요 - [점검]" >> S1~73/bad/[S-58]bad.txt
cat S1~73/bad/[S-58]bad.txt >> S1~73/inspect.txt
echo -e "[S-58] cat /etc/passwd 명령으로 모든 사용자 계정이 적절한 홈 디렉토리를 갖는지 확인한 후 홈 디렉토리가 존재하지 않는 계정이 발견된 경우 vi 편집기로 수정" >> S1~73/action/[S-58]action.txt
if [ -f "S1~73/action/[S-58]action.txt" ];then
        echo -e "\n[(S-58)조치사항]
1. cat /etc/passwd 명령으로 파일 내 존재하는 모든 계정이 적절한 홈 디렉토리를 갖는지 확인
2. 홈 디렉토리가 없는 계정일 경우 계정 삭제 또는 홈 디렉토리 지정
 userdel <user_name>
 또는
 vi /etc/passwd 후 홈 디렉토리 지정" >> S1~73/Action.txt
fi

##########[S-59]숨겨진 파일 및 디렉토리 검색 및 제거##########

stat=$(find / -name ".*" -type f)
stat2=$(find / -name ".*" -type d)

echo -e "\n##########[S-59]숨겨진 파일 및 디렉토리 검색 및 제거##########\n[숨겨진 파일]\n$stat\n[숨겨진 디렉토리]\n$stat2" >> S1~73/log/[S-59]log.txt
cat S1~73/log/[S-59]log.txt >> S1~73/log.txt
echo -e "B|[S-59] 불필요하거나 의심스러운 숨겨진 파일 및 디렉토리가 있는지 점검 필요 - [점검]" >> S1~73/bad/[S-59]bad.txt
cat S1~73/bad/[S-59]bad.txt >> S1~73/inspect.txt
echo -e "[S-59] 특정 디렉토리 내 불필요한 파일 점검
 ls -al <디렉토리 명>
전체 숨김 디렉토리 및 숨김 파일 점검
 find / -type f -name '.*' ( 파일 점검)
 find / -type d -name '.*' ( 디렉토리 점검)" >> S1~73/action/[S-59]action.txt
if [ -f "S1~73/action/[S-59]action.txt" ];then
        echo -e "\n[(S-59)조치사항]
1. 숨겨진 파일 목록에서 불필요한 파일 삭제
특정 디렉토리 내 불필요한 파일 점검
 ls -al <디렉토리 명>
전체 숨김 디렉토리 및 숨김 파일 점검
 find / -type f -name '.*' ( 파일 점검)
 find / -type d -name '.*' ( 디렉토리 점검)
2. 마지막으로 변경된 시간에 따라, 최근 작업한 파일 확인 시 [-t] 플래그 사용" >> S1~73/Action.txt
fi

##########[S-60]ssh 원격 접속 허용##########

stat=$(svcs -a | grep ssh)

echo -e "\n##########[S-60]ssh 원격 접속 허용##########\n[ssh 서비스 현황]\n$stat" >> S1~73/log/[S-60]log.txt
cat S1~73/log/[S-60]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | awk '{print$1}')" == "online" ];then
        echo -e "C|[S-60]원격 접속 시 SSH 프로토콜을 사용하고 있습니다 - [양호]" >> S1~73/good/[S-60]good.txt
	cat S1~73/good/[S-60]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-60]원격 접속 시 SSH 프로토콜을 사용하고 있지 않습니다 - [취약]" >> S1~73/bad/[S-60]bad.txt
	cat S1~73/bad/[S-60]bad.txt >> S1~73/inspect.txt
	echo -e "[S-60] svcadm enable ssh 명령으로 ssh 서비스 활성화" >> S1~73/action/[S-60]action.txt
fi

if [ -f "S1~73/action/[S-60]action.txt" ];then
        echo -e "\n[(S-60)조치사항]
1. SSH 서비스 활성화
 svcadm enable ssh
2. SSH 설치가 필요할 경우 각 OS 벤더사로부터 SSH 서비스 설치 방법 문의 후 서버에 설치" >> S1~73/Action.txt
fi

##########[S-61]ftp 서비스 확인##########

stat=$(svcs -a | grep ftp:default)
stat2=$(ps -ef | egrep "vsftpd|proftp" | grep -v grep)

echo -e "\n##########[S-61]ftp 서비스 확인##########\n[ftp 사용여부]\n$stat\n[vsftpd, proftp 사용여부]\n$stat2" >> S1~73/log/[S-61]log.txt
cat S1~73/log/[S-61]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep "online")" ];then
        echo -e "C|[S-61]일반 ftp를 사용하고 있습니다 - [취약]" >> S1~73/bad/[S-61]bad.txt
	cat S1~73/bad/[S-61]bad.txt >> S1~73/inspect.txt
	echo -e "[S-61] svcs | grep ftp 후 나온 ftp 서비스 svcadm disable 명령으로 비활성화" >> S1~73/action/[S-61]action.txt
else
        echo -e "C|[S-61]일반 ftp를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-61]good.txt
	cat S1~73/good/[S-61]good.txt >> S1~73/inspect.txt
fi
if [ "$stat2" ];then
        echo -e "C|[S-61]vsftpd 또는 ProFTP를 사용하고 있습니다 - [취약]" >> S1~73/bad/[S-61]bad.txt
	cat S1~73/bad/[S-61]bad.txt >> S1~73/inspect.txt
	echo -e "[S-61] ps -ef | egrep "vsftpd|proftpd" 명령으로 해당 서비스 확인 후 service vsftpd(또는 proftp) stop 또는 /etc/rc.d/init.d/vsftpd(또는 proftp) stop 또는 kill -9 <pid>" >> S1~73/action/[S-61]action.txt
else
        echo -e "C|[S-61]vsftpd 또는 ProFTP를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-61]good.txt
	cat S1~73/good/[S-61]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-61]action.txt" ];then
        echo -e "\n[(S-61)조치사항]
1. 일반 FTP 서비스 중지 방법
 svcs | grep ftp 후 나온 ftp 서비스 svcadm disable 명령으로 비활성화
 예) svcadm disable svc:/network/ftp:default

2. vsFTP, ProFTP 서비스 중지 방법
 1) 서비스 확인
  ps -ef | egrep "vsftpd|proftpd"
 2) 서비스 데몬 중지
  service vsftpd(또는 proftp) stop 또는 /etc/rc.d/init.d/vsftpd(또는 proftp) stop 또는 kill -9 <pid>" >> S1~73/Action.txt
fi

##########[S-62]ftp 계정 shell 제한##########

stat=$(cat /etc/passwd | grep ftp)

echo -e "\n##########[S-62]ftp 계정 shell 제한##########\n[ftp shell 사용 여부]\n$stat" >> S1~73/log/[S-62]log.txt
cat S1~73/log/[S-62]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | awk -F":" '{print $7}')" == "/bin/false" ];then
        echo -e "C|[S-62]passwd 파일 내 ftp 로그인 쉘 설정이 /bin/false 입니다 - [양호]" >> S1~73/good/[S-62]good.txt
	cat S1~73/good/[S-62]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-62]passwd 파일 내 ftp 로그인 쉘 설정이 /bin/false가 아닙니다 - [취약]" >> S1~73/bad/[S-62]bad.txt
	cat S1~73/bad/[S-62]bad.txt >> S1~73/inspect.txt
	echo -e "[S-62] vi 편집기를 이용하여 /etc/passwd 파일을 연 후 ftp 계정의 로그인 쉘 부분인 계정 맨 마지막에 /bin/false 부여 및 변경 또는 usermod -s /bin/false <계정ID> 부여로 변경 가능" >> S1~73/action/[S-62]action.txt
fi

if [ -f "S1~73/action/[S-62]action.txt" ];then
        echo -e "\n[(S-62)조치사항]
1. vi 편집기를 이용하여 /etc/passwd 파일 열기
2. ftp 계정의 로그인 쉘 부분인 계정 맨 마지막에 /bin/false 부여 및 변경
3. usermod -s /bin/false <계정ID> 부여로 변경 가능
만약 2번 방법으로 적용이 되지 않을 때 3번의 usermod 명령어를 사용하여 쉘 변경" >> S1~73/Action.txt
fi

##########[S-63]ftpusers 파일 소유자 및 권한 설정##########

stat=$(ls -al /etc/ftpd/ftpusers)
chk=$(stat -c %a /etc/ftpd/ftpusers)
chk2=$(echo $stat | awk '{print$3}')

echo -e "\n##########[S-63]ftpusers 파일 소유자 및 권한 설정##########\nftpusers 파일 소유자 : $chk2\nftpusers 파일 권한 : $chk" >> S1~73/log/[S-63]log.txt
cat S1~73/log/[S-63]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | awk '{print$3}')" == "root" ];then
        echo -e "C|[S-63]ftpusers 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-63]good.txt
	cat S1~73/good/[S-63]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-63]ftpusers 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-63]bad.txt
	cat S1~73/bad/[S-63]bad.txt >> S1~73/inspect.txt
	echo -e "[S-63] /etc/ftpusers 파일의 소유자 변경(소유자 root)" >> S1~73/action/[S-63]action.txt
fi
if [ "$chk" -le 640 ];then
        echo -e "C|[S-63]ftpusers 파일의 권한이 640 이하입니다 - [양호]" >> S1~73/good/[S-63]good.txt
	cat S1~73/good/[S-63]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-63]ftpusers 파일의 권한이 640보다 높습니다 - [취약]" >> S1~73/bad/[S-63]bad.txt
	cat S1~73/bad/[S-63]bad.txt >> S1~73/inspect.txt
	echo -e "[S-63] /etc/ftpusers 파일의 권한 변경 (권한 640 이하)" >> S1~73/action/[S-63]action.txt
fi

if [ -f "S1~73/action/[S-63]action.txt" ];then
        echo -e "\n[(S-63)조치사항]
1. /etc/ftpusers 파일의 소유자 및 권한 확인
 ls -l /etc/ftpusers
2. /etc/ftpusers 파일의 소유자 및 권한 변경(소유자 root, 권한 640 이하)
 chown root /etc/ftpusers
 chmod 640 /etc/ftpusers" >> S1~73/Action.txt
fi

##########[S-64]ftpusers 파일 설정(FTP 서비스 root 계정 접근 제한)##########

stat=$(cat /etc/ftpd/ftpusers)

echo -e "\n##########[S-64]ftpusers 파일 설정(FTP 서비스 root 계정 접근 제한)##########\n[ftpusers 파일 설정 현황]\n$stat" >> S1~73/log/[S-64]log.txt
cat S1~73/log/[S-64]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | grep root)" ];then
        if [ "$(echo "$stat" | grep root | cut -c 1)" == "#" ];then
                echo -e "C|[S-64]root 계정 접속을 허용하였습니다 - [취약]" >> S1~73/bad/[S-64]bad.txt
		cat S1~73/bad/[S-64]bad.txt >> S1~73/inspect.txt
		echo -e "[S-64] vi 편집기로 /etc/ftpusers 파일을 열어 root 앞에 주석제거" >> S1~73/action/[S-63]action.txt
        else
                echo -e "C|[S-64]root 계정 접속을 차단하였습니다 - [양호]" >> S1~73/good/[S-64]good.txt
		cat S1~73/good/[S-64]good.txt >> S1~73/inspect.txt
        fi
else
        echo -e "C|[S-64]root 계정에 대한 설정이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-64]bad.txt
	cat S1~73/bad/[S-64]bad.txt >> S1~73/inspect.txt
	echo -e "[S-64] vi 편집기로 /etc/ftpd/ftpusers 파일을 열어 root 추가" >> S1~73/action/[S-64]action.txt
fi

if [ -f "S1~73/action/[S-64]action.txt" ];then
        echo -e "\n[(S-64)조치사항]
1. vi 편집기를 이용하여 /etc/ftpd/ftpusers 파일 열기
2. root에 대한 설정이 없거나 root 앞에 주석처리가 되어 있을 경우 root 앞에 주석 제거 또는 root 추가" >> S1~73/Action.txt
fi

##########[S-65]at 서비스 권한 설정##########

stat=$(ls -al /etc/cron.d | grep at)

echo -e "\n##########[S-65]at 서비스 권한 설정##########\n[at 파일 현황]\n$stat" >> S1~73/log/[S-65]log.txt
cat S1~73/log/[S-65]log.txt >> S1~73/log.txt

if [ "$(ls /etc/cron.d | grep at.allow)" ];then
        if [ "$(ls -al /etc/cron.d/at.allow | awk '{print$3}')" == "root" ];then
                echo -e "C|[S-65]at.allow 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-65]good.txt
		cat S1~73/good/[S-65]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-65]at.allow 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-65]bad.txt
		cat S1~73/bad/[S-65]bad.txt >> S1~73/inspect.txt
		echo -e "[S-65] /etc/cron.d 폴더 내 at.allow 파일의 소유자를 root로 변경" >> S1~73/action/[S-65]action.txt
        fi
        if [ "$(stat -c %a /etc/cron.d/at.allow)" -le 640 ];then
                echo -e "C|[S-65]at.allow 파일의 권한이 640 이하입니다 - [양호]" >> S1~73/good/[S-65]good.txt
		cat S1~73/good/[S-65]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-65]at.allow 파일의 권한이 640보다 높습니다 - [취약]" S1~73/good/[S-65]good.txt
		cat S1~73/good/[S-65]good.txt >> S1~73/inspect.txt
		echo -e "[S-65] /etc/cron.d 폴더 내 at.allow 파일의 권한을 640 이하로 설정" >> S1~73/action/[S-65]action.txt
        fi
else
        echo -e "C|[S-65]at.allow 파일이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-65]bad.txt
	cat S1~73/bad/[S-65]bad.txt >> S1~73/inspect.txt
	echo -e "[S-65] /etc/cron.d 폴더 내 at.allow 파일 생성" >> S1~73/action/[S-65]action.txt
fi
if [ "$(ls /etc/cron.d | grep at.deny)" ];then
        if [ "$(ls -al /etc/cron.d/at.deny | awk '{print$3}')" == "root" ];then
                echo -e "C|[S-65]at.deny 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-65]good.txt
		cat S1~73/good/[S-65]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-65]at.deny 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-65]bad.txt
		cat S1~73/bad/[S-65]bad.txt >> S1~73/inspect.txt
		echo -e "[S-65] /etc/cron.d 폴더 내 at.deny 파일의 소유자를 root로 변경" >> S1~73/action/[S-65]action.txt
        fi
        if [ "$(stat -c %a /etc/cron.d/at.deny)" -le 640 ];then
                echo -e "C|[S-65]at.deny 파일의 권한이 640 이하입니다 - [양호]" >> S1~73/good/[S-65]good.txt
		cat S1~73/good/[S-65]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-65]at.deny 파일의 권한이 640보다 높습니다 - [취약]" >> S1~73/bad/[S-65]bad.txt
		cat S1~73/bad/[S-65]bad.txt >> S1~73/inspect.txt
		echo -e "[S-65] /etc/cron.d 폴더 내 at.deny 파일의 권한을 640 이하로 설정" >> S1~73/action/[S-65]action.txt
        fi
else
        echo -e "C|[S-65]at.deny 파일이 존재하지 않습니다 - [취약]" >> S1~73/bad/[S-65]bad.txt
	cat S1~73/bad/[S-65]bad.txt >> S1~73/inspect.txt
	echo -e "[S-65] /etc/cron.d 폴더 내 at.deny 파일을 생성" >> S1~73/action/[S-65]action.txt
fi

if [ -f "S1~73/action/[S-65]action.txt" ];then
        echo -e "\n[(S-65)조치사항]
1. /etc/cron.d 폴더 내 at.allow 파일 및 at.deny 파일이 존재하지 않을 시 생성
2. at.allow 파일 및 at.deny 파일의 소유자 및 권한 설정(소유자 root, 권한 640 이하)" >> S1~73/Action.txt
fi

##########[S-66]SNMP 서비스 구동 점검##########

stat=$(svcs -a | grep -i "net-snmp")

echo -e "\n##########[S-66]SNMP 서비스 구동 점검##########\n[SNMP 서비스 현황]\n$stat" >> S1~73/log/[S-66]log.txt
cat S1~73/log/[S-66]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | awk '{print$1}')" == "online" ];then
        echo -e "C|[S-66]SNMP 서비스를 사용 중 입니다 - [취약]" >> S1~73/bad/[S-66]bad.txt
	cat S1~73/bad/[S-66]bad.txt >> S1~73/inspect.txt
	echo -e "[S-66] svcs -a | grep snmp 명령으로 데몬을 확인 후 svcadm disable 명령으로 해당 데몬 중지" >> S1~73/action/[S-66]action.txt
else
        echo -e "C|[S-66]SNMP 서비스를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-66]good.txt
	cat S1~73/good/[S-66]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-66]action.txt" ];then
        echo -e "\n[(S-66)조치사항]
1. svcs -a | grep snmp 명령으로 데몬 확인
2. 활성화 된 데몬 중지
 svcadm disable <서비스>
 예) svcadm disable svc:/application/management/snmpdx
     svcadm disable svs:/application/management/dmi:default" >> S1~73/Action.txt
fi

##########[S-67]SNMP 서비스 Community String 복잡성 설정##########

stat=$(cat /etc/sma/snmp/snmpd.conf 2>/dev/null | egrep -i "rocommunity|rwcommunity")

echo -e "\n##########[S-67]SNMP 서비스 Community String 복잡성 설정##########\n[Community 설정 현황]\n$stat" >> S1~73/log/[S-67]log.txt
cat S1~73/log/[S-67]log.txt >> S1~73/log.txt

if [ -e "/etc/sma/snmp/snmpd.conf" ];then
        if [ "$(cat /etc/sma/snmp/snmpd.conf | grep -i rocommunity | grep public)" ];then
                echo -e "C|[S-67]커뮤니티 명이 기본 값인 public으로 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-67]bad.txt
		cat S1~73/bad/[S-67]bad.txt >> S1~73/inspect.txt
		echo -e "[S-67] vi 편집기를 이용하여 /etc/sma/snmp/snmpd.conf 파일을 연 후 rocommunity 뒤에 이름을 public이 아닌 다른 이름으로 설정" >> S1~73/action/[S-67]action.txt
        else
                echo -e "C|[S-67]커뮤니티 명을 따로 설정하셨습니다 - [양호]" >> S1~73/good/[S-67]good.txt
		cat S1~73/good/[S-67]good.txt >> S1~73/inspect.txt
        fi
        if [ "$(cat /etc/sma/snmp/snmpd.conf | grep -i rwcommunity | grep private)" ];then
                echo -e "C|[S-67]커뮤니티 명이 기본 값이 private로 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-67]bad.txt
                cat S1~73/bad/[S-67]bad.txt >> S1~73/inspect.txt
		echo -e "[S-67] vi 편집기를 이용하여 /etc/sma/snmp/snmpd.conf 파일을 연 후 rwcommunity 뒤에 이름을 private가 아닌 다른 이름으로 설정" >> S1~73/action/[S-67]action.txt
        else
                echo -e "C|[S-67]커뮤니티 명을 따로 설정하셨습니다 - [양호]" >> S1~73/good/[S-67]good.txt
                cat S1~73/good/[S-67]good.txt >> S1~73/inspect.txt
        fi
else
        echo -e "C|[S-67]snmp.conf 파일이 존재하지 않습니다 - [점검]" >> S1~73/bad/[S-67]bad.txt
	cat S1~73/bad/[S-67]bad.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-67]action.txt" ];then
        echo -e "\n[(S-67)조치사항]
1. vi 편집기를 이용하여 /etc/sma/snmp/snmp.conf 파일 열기
2. rocommunity 및 rwcommunity 뒤에 설정 값을 public, private가 아닌 다른 이름으로 설정" >> S1~73/Action.txt
fi

##########[S-68]로그온 시 경고 메시지 제공##########

Server=$(cat /etc/motd)
Telnet=$(cat /etc/default/telnetd 2>/dev/null | grep -v "#" | grep -i "banner=")
FTP=$(cat /etc/default/ftpd 2>/dev/null | grep -i "banner=")
SMTP=$(cat /etc/mail/sendmail.cf 2>/dev/null | grep -i "GreetingMessage=")
DNS=$(cat /etc/named.conf 2>/dev/null)

echo -e "\n##########[S-68]로그온 시 경고 메시지 제공##########\n[Server]\n$Server\n[Telnet]\n$Telnet\n[FTP]\n$FTP\n[SMTP]\n$SMTP\n[DNS]\n$DNS" >> S1~73/log/[S-68]log.txt
cat S1~73/log/[S-68]log.txt >> S1~73/log.txt

if [ "$Server" ];then
        echo -e "C|[S-68] Server 로그온 메시지를 설정하셨습니다 - [양호]" >> S1~73/good/[S-68]good.txt
	cat S1~73/good/[S-68]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-68]Server 로그온 메시지를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-68]bad.txt
	cat S1~73/bad/[S-68]bad.txt >> S1~73/inspect.txt
	echo -e "[S-68] vi /etc/motd 명령으로 해당 파일을 연 후 Server 로그온 메시지 설정" >> S1~73/action/[S-68]action.txt
fi
if [ "$Telnet" ];then
        echo -e "C|[S-68]Telnet 로그온 메시지를 설정하셨습니다 - [양호]" >> S1~73/good/[S-68]good.txt
	cat S1~73/good/[S-68]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-68]Telnet 로그온 메시지를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-68]bad.txt
        cat S1~73/bad/[S-68]bad.txt >> S1~73/inspect.txt
	echo -e "[S-68] vi /etc/default/telnetd 명령으로 해당 파일을 연 후 Telnet 로그온 메시지 설정" >> S1~73/action/[S-68]action.txt
fi
if [ "$FTP" ];then
        echo -e "C|[S-68]FTP 로그인 메시지를 설정하셨습니다 - [양호]" >> S1~73/good/[S-68]good.txt
        cat S1~73/good/[S-68]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-68]FTP 로그인 메시지를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-68]bad.txt
        cat S1~73/bad/[S-68]bad.txt >> S1~73/inspect.txt
	echo -e "[S-68] vi /etc/default/ftpd 명령으로 해당 파일을 연 후 FTP 로그인 메시지 설정" >> S1~73/action/[S-68]action.txt
fi
if [ "$SMTP" ];then
        echo -e "C|[S-68]SMTP 로그인 메시지를 설정하셨습니다 - [양호]" >> S1~73/good/[S-68]good.txt
        cat S1~73/good/[S-68]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-68]SMTP 로그인 메시지를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-68]bad.txt
        cat S1~73/bad/[S-68]bad.txt >> S1~73/inspect.txt
	echo -e "[S-68] vi /etc/mail/sendmail.cf 명령으로 해당 파일을 연 후 SMTP 로그인 메시지 설정" >> S1~73/action/[S-68]action.txt
fi
if [ "$DNS" ];then
        echo -e "C|[S-68]DNS 로그인 메시지를 설정하셨습니다 - [양호]" >> S1~73/good/[S-68]good.txt
        cat S1~73/good/[S-68]good.txt >> S1~73/inspect.txt
else
        echo -e "C|[S-68]DNS 로그인 메시지를 설정하지 않았습니다 - [취약]" >> S1~73/bad/[S-68]bad.txt
        cat S1~73/bad/[S-68]bad.txt >> S1~73/inspect.txt
	echo -e "[S-68] vi /etc/named.conf 명령으로 해당 파일을 연 후 DNS 로그인 메시지 설정" >> S1~73/action/[S-68]action.txt
fi

if [ -f "S1~73/action/[S-68]action.txt" ];then
        echo -e "\n[(S-68)조치사항]
1. 서버 로그온 메시지 설정: vi 편집기로 /etc/motd 파일을 연 후 로그온 메시지 입력
 vi /etc/motd
 경고 메시지 입력
2. Telnet 배너 설정: vi 편집기로 /etc/default/telnetd 파일을 연 후 로그온 메시지 입력
 vi /etc/default/telnetd
 BANNER='WARNING:Authorized use only' or BANNER=''
3. FTP 배너 설정: vi 편집기로 /etc/default/ftpd 파일을 연 후 로그인 메시지 입력
 vi /etc/default/ftpd
 BANNER='WARNING:Authorized use only' or BANNER=''
4. SMTP 배너 설정: vi 편집기로 /etc/mail/sendmail.cf 파일을 연 후 로그인 메시지 입력
 vi /etc/mail/sendmail.cf
 O Smtp GreetingMessage='경고 메시지 입력'
5. DNS 배너 설정: vi 편집기로 /etc/named.conf 파일을 연 후 로그인 메시지 입력
 vi /etc/named.conf" >> S1~73/Action.txt
fi

##########[S-69]NFS 설정파일 접근권한##########

chk=$(ls -al /etc/dfs/dfstab | awk '{print$3}')
chk2=$(stat -c %a /etc/dfs/dfstab)

echo -e "\n##########[S-69]NFS 설정파일 접근 권한##########\n[/etc/dfs/dfstab]\n소유자 : $chk\n파일 권한 : $chk2" >> S1~73/log/[S-69]log.txt
cat S1~73/log/[S-69]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$chk" == "root" ];then
                echo -e "C|[S-69]dfstab 파일의 소유자가 root 입니다 - [양호]" >> S1~73/good/[S-69]good.txt
		cat S1~73/good/[S-69]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-69]dfstab 파일의 소유자가 root가 아닙니다 - [취약]" >> S1~73/bad/[S-69]bad.txt
		cat S1~73/bad/[S-69]bad.txt >> S1~73/inspect.txt
		echo -e "[S-69] /etc/dfs/dfstab 파일의 소유자를 root로 변경" >> S1~73/action/[S-69]action.txt
        fi
        if [ "$chk2" -le 644 ];then
                echo -e "C|[S-69]dfstab 파일의 권한이 644 이하입니다 - [양호]" >> S1~73/good/[S-69]good.txt
                cat S1~73/good/[S-69]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-69]dfstab 파일의 권한이 644 보다 높습니다 - [취약]" >> S1~73/bad/[S-69]bad.txt
                cat S1~73/bad/[S-69]bad.txt >> S1~73/inspect.txt
		echo -e "[S-69] /etc/dfs/dfstab 파일의 권한을 644 이하로 설정" >> S1~73/action/[S-69]action.txt
        fi
else
        echo -e "C|[S-69]/etc/dfs/dfstab 파일이 존재하지 않습니다 - [점검]" >> S1~73/bad/[S-69]bad.txt
	cat S1~73/bad/[S-69]bad.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-]action.txt" ];then
        echo -e "\n[(S-)조치사항]
1. vi 편집기를 이용하여 /etc/dfs/dfstab 파일의 소유자 및 권한 변경 (소유자 root, 권한 644이하)
 chown root /etc/dfs/dfstab
 chmod 644 /etc/dfs/dfstab" >> S1~73/Action.txt
fi

##########[S-70]expn, vrfy 명령어 제한##########

stat=$(ps -ef | grep sendmail | grep -v grep)
chk=$(cat /etc/mail/sendmail.cf | grep -i "PrivacyOptions=")

echo -e "\n##########[S-70]expn, vrfy 명령어 제한##########\n[Sendmail 사용 현황]\n$stat\n[PrivacyOptions 현황]\n$chk" >> S1~73/log/[S-70]log.txt
cat S1~73/log/[S-70]log.txt >> S1~73/log.txt

if [ "$stat" ];then
        if [ "$(echo "$stat" | egrep -i "noexpn|novrfy|goaway")" ];then
                echo -e "C|[S-70]Sendmail 서비스를 사용하고, 'noexpn', 'novrfy', 'goaway' 옵션을 사용하고 있습니다 - [양호]" >> S1~73/good/[S-70]good.txt
		cat S1~73/good/[S-70]good.txt >> S1~73/inspect.txt
        else
                echo -e "C|[S-70]Sendmail 서비스를 사용하지만, 'noexpn', 'novrfy', 'goaway' 옵션을 사용하고 있지 않습니다 - [취약]" >> S1~73/bad/[S-70]bad.txt
		cat S1~73/bad/[S-70]bad.txt >> S1~73/inspect.txt
		echo -e "[S-70]vi 편집기를 이용하여 /etc/mail/sendmail.cf 파일을 열어 PrivacyOptions= 뒤에 noexpn, novrfy 또는 goaway 옵션 설정" >> S1~73/action/[S-70]action.txt
        fi
else
        echo -e "C|[S-70]Sendmail 서비스를 사용하고 있지 않습니다 - [양호]" >> S1~73/good/[S-70]good.txt
	cat S1~73/good/[S-70]good.txt >> S1~73/inspect.txt
fi

if [ -f "S1~73/action/[S-70]action.txt" ];then
        echo -e "\n[(S-70)조치사항]
1. vi 편집기를 이용하여 /etc/mail/sendmail.cf 파일 열기
2. PrivacyOptions 지시자 뒤에 noexpn, novrfy 또는 goaway 옵션 사용" >> S1~73/Action.txt
fi

##########[S-72]정책에 따른 시스템 로깅 설정##########

stat=$(svcs -a | grep "system-log:default")
debug=$(cat /etc/syslog.conf | grep -w "mail.debug")
info=$(cat /etc/syslog.conf | grep -w "*.info")
alert=$(cat /etc/syslog.conf | grep -w "*.alert")
emerg=$(cat /etc/syslog.conf | grep -w "*.emerg")

echo -e "\n##########[S-72]정책에 따른 시스템 로깅 설정##########\n[syslog.conf 설정 현황]\n$debug\n$info\n$alert\n$emerg" >> S1~73/log/[S-73]log.txt
cat S1~73/log/[S-73]log.txt >> S1~73/log.txt

if [ "$(echo "$stat" | awk '{print$1}')" == "online" ];then
        if [ "$debug" ];then
                if [ "$(echo "$debug" | awk '{print$2}')" == "/var/log/mail.log" ];then
                        echo -e "E|[S-72]mail.debug의 로그 경로가 로그 기록 정책에 맞게 설정되어 있습니다 - [양호]" >> S1~73/good/[S-72]good.txt
			cat S1~73/good/[S-72]good.txt >> S1~73/inspect.txt
                else
                        echo -e "E|[S-72]mail.debug의 로그 경로가 로그 기록 정책에 맞지 않게 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
			cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
			echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
mail.debug	/var/log/mail.log" >> S1~73/action/[S-72]action.txt
                fi
        else
                echo -e "E|[S-72]mail.debug 관련 설정이 없습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
		cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
		echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
mail.debug      /var/log/mail.log" >> S1~73/action/[S-72]action.txt
        fi
        if [ "$info" ];then
                if [ "$(echo "$info" | awk '{print$2}')" == "/var/log/syslog.log" ];then
                        echo -e "E|[S-72]info의 로그 경로가 로그 기록 정책에 맞게 설정되어 있습니다 - [양호]" >> S1~73/good/[S-72]good.txt
                        cat S1~73/good/[S-72]good.txt >> S1~73/inspect.txt
                else
                        echo -e "E|[S-72]info의 로그 경로가 로그 기록 정책에 맞지 않게 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
                        cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
			echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
*.info      /var/log/syslog.log" >> S1~73/action/[S-72]action.txt
			
                fi
        else
                echo -e "E|[S-72]info 관련 설정이 없습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
                cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
		echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
*.info      /var/log/syslog.log" >> S1~73/action/[S-72]action.txt
        fi
        if [ "$alert" ];then
                alert_route=$(echo "$alert" | awk '{print$2}')
                if [ "$alert_route" == "/var/log/syslog.log" ] || [ "$alert_route" == "/dev/console" ] || [ "$alert_route" == "root" ];then
                        echo -e "E|[S-72]alert의 로그 경로가 로그 기록 정책에 맞게 설정되어 있습니다 - [양호]" >> S1~73/good/[S-72]good.txt
                        cat S1~73/good/[S-72]good.txt >> S1~73/inspect.txt
                else
                        echo -e "E|[S-72]alert의 로그 경로가 로그 기록 정책에 맞지 않게 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
                        cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
			echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
*.alert      /var/log/syslog.log
*.alert	     /dev/console
*.alert	     root" >> S1~73/action/[S-72]action.txt
                fi
        else
                echo -e "E|[S-72]alert 관련 설정이 없습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
                cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
		echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
*.alert      /var/log/syslog.log
*.alert      /dev/console
*.alert      root" >> S1~73/action/[S-72]action.txt
        fi
        if [ "$emerg" ];then
                if [ "$(echo "$emerg" | awk '{print$2}')" == "*" ];then
                        echo -e "E|[S-72]emerg의 로그 경로가 로그 기록 정책에 맞게 설정되어 있습니다 - [양호]" >> S1~73/good/[S-72]good.txt
                        cat S1~73/good/[S-72]good.txt >> S1~73/inspect.txt
                else
                        echo -e "E|[S-72]emerg의 로그 경로가 로그 기록 정책에 맞지 않게 설정되어 있습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
                        cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
                fi
        else
                echo -e "E|[S-72]emerg 관련 설정이 없습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
		cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
		echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
*.emerg      *" >> S1~73/action/[S-72]action.txt
        fi
else
        echo -e "E|[S-72]system-log 서비스를 사용하고 있지 않습니다 - [취약]" >> S1~73/bad/[S-72]bad.txt
        cat S1~73/bad/[S-72]bad.txt >> S1~73/inspect.txt
	echo -e "[S-72] vi 편집기를 이용하여 /etc/syslog.conf 파일을 열어 아래와 같이 수정 또는 신규 삽입
*.emerg      *" >> S1~73/action/[S-72]action.txt
fi

if [ -f "S1~73/action/[S-72]action.txt" ];then
        echo -e "\n[(S-72)조치사항]
1. vi 편집기를 이용하여 /etc/syslog.conf 파일 열기
아래와 같이 수정 또는 신규 삽입
mail.debug	 /var/log/mail.log
*.info		 /var/log/syslog.log
*.alert		 /var/log/syslog.log
*.alert		 /dev/console
*.alert		 root
*.emerg		 *

2. 위와 같이 설정 후 SYSLOG 데몬 재시작
 예)
 svcs -a | grep system-log
  online 16:23:03 svc:/system/system-log:default
 svcadm disable svc:/system/system-log:default
 svcadm enable svc:/system/system-log:default" >> S1~73/Action.txt
fi

