@echo off
echo ---------------------------------------------윈도우서버 취약점 점검----------------------------------
echo 			         [W-01] ~ [W-82]까지의 항목을 점검합니다.
echo.
echo Windows Server 2012 R2를 기준으로 제작된 코드입니다.이하 버전에 대해서는 점검이 정상진행 되지 않을 수 있습니다.
echo bad항목에서 번호 뒤에 S가 붙는 항목은 담당자와 상의하여 직접 점검해야하는 항목입니다.
echo bad항목에서 번호 뒤에 SS가 붙으면 Windows Server 2012 이하 버전에서만 해당하기에 직접 점검해야 하는 항목입니다.

mkdir C:\check\w1~82

rem #################################################################
echo [W-01] Administrator 계정 이름 변경
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#[W-01] Administrator 계정 이름 변경^#^#^#^#^# >> C:\check\w1~82/log.txt

net user > account.txt
net user >> C:\check\w1~82/log.txt

type account.txt | find /I "Administrator" > NUL
if %errorlevel% EQU 0 (
	echo A^|[W-01]  Administrator 계정이 존재함 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-01] 시작- 프로그램- 제어판- 관리도구- 로컬 보안 정책 - 로컬 정책 - 보안옵션 >> C:\check\w1~82/Action.txt
	echo [W-01] 계정: Administrator 계정 이름 바꾸기를 유추하기 어려운 계정 이름으로 변경 >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-01] Administrator 계정이 존재하지 않음 - [양호] >> C:\check\w1~82/inspect.txt
)

del account.txt


rem #################################################################
echo [W-02] Guest 계정 상태
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-02] Guest 계정 상태 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net user guest >> C:\check\w1~82/log.txt
net user guest | find "활성 계정" | find "아니요" > NUL
if %errorlevel% EQU  0 (
	echo A^|[W-02] Guest 계정이 비활성화되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-02] Guest 계정이 활성화되어 있음 -  [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-02] 시작- 실행- LUSRMGR.MSC 사용자- GUEST- 속성 계정 사용 안함에 체크 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-03] 불필요한 계정 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^# [W-03] 불필요한 계정 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net user >> C:\check\w1~82/log.txt

echo A^|[W-03] 불필요한 계정이 존재하는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-03] C:\check\w1~82/log.txt 파일을 확인후 "net user 계정명 /delete" 을 입력하여 불필요한 계정을 제거하시오 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-04] 계정 잠금 임계값 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-04] 계정 잠금 임계값 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find "임계값" >> C:\check\w1~82/log.txt
net accounts | find "임계값" > thres.txt

for /f "tokens=3" %%a in (thres.txt) do set thres=%%a
if %thres% leq 5 (
	echo A^|[W-04] 임계값이 5 이하값으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-04] 임계값이 6 이상으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-04] 시작 - 실행 - secpol.msc - 계정 정책 - 계정 잠금 정책 >> C:\check\w1~82/Action.txt
	echo [W-04] 계정 잠금 임계값을 5이하로 설정  >> C:\check\w1~82/Action.txt
)

del thres.txt



rem #################################################################
echo [W-05] 해독 가능한 암호화를 사용하여 암호 저장 해제
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-05] 해독 가능한 암호화를 사용하여 암호 저장 해제 ^#^#^#^#^# >> C:\check\w1~82/log.txt


secedit /export /cfg secpol.txt

type secpol.txt | find /I "ClearTextPassword" | find "0" > NUL
if %errorlevel% EQU 0 (
	echo A^|[W-05] '사용 안 함'으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-05] '사용'으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>>C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-05] 시작-실행-SECPOL.MSC-계정 정책-암호 정책 - 해독 가능한 암호화를 사용하여 암호 저장 설정확인 >> C:\check\w1~82/Action.txt
	echo [W-05] 해독 가능한 암호화를 사용하여 암호 저장을 사용 안 함으로 설정 >> C:\check\w1~82/Action.txt
)

type secpol.txt | find /I "ClearTextPassword" >> C:\check\w1~82/log.txt

del secpol.txt

rem #################################################################
echo [W-06] 관리자 그룹에 최소한의 사용자 포함
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-06] 관리자 그룹에 최소한의 사용자 포함 ^#^#^#^#^# >> C:\check\w1~82/log.txt


net localgroup administrators | find /v "명령을 잘 실행했습니다." >> C:\check\w1~82/log.txt

echo A^|[W-06] Administrators 그룹에 불필요한 관리자 계정이 존재하는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-06] C:\check\w1~82/log.txt 파일을 확인후 관리자 그룹에 포함된 불필요한 계정을 확인, 담당자와 상의하여 >> C:\check\w1~82/Action.txt
echo 시작-실행-LUSRMGR.MSC-그룹-Administrators-속성-Administrators 그룹에서 불필요 계정 제거 후 그룹 변경 >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-07] 공유 권한 및 사용자 그룹 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-07] 공유 권한 및 사용자 그룹 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net share >> C:\check\w1~82/log.txt
echo B^|[W-07] 일반 공유 디렉토리의 접근 권한에 Everyone 권한이 있는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-07] C:\check\w1~82/log.txt 파일에서 공유가 진행되고 있는 폴더 목록을 확인후 사용 권한에서 Everyone으로 된 공유를 제거 >> C:\check\w1~82/Action.txt
echo 시작-실행-FSMGMT.MSC-공유-사용 권한에서 Everyone으로 된 공유를 제거하고 접근이 필요한 계정의 적절한 권한 추가 >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-08] 하드디스크 기본 공유 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-08] 하드디스크 기본 공유 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net share > log.txt
net share | find /v "명령을 잘 실행했습니다." >> C:\check\w1~82/log.txt

type log.txt | findstr /I "C$ D$ IPC$" > NUL
if %errorlevel% EQU 0 (
	echo B^|[W-08] 하드디스크 기본 공유 제거됨 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-08] 하드디스크 기본 공유 제거 안 됨 - [취약] >> C:\check\w1~82/inspect.txt
	goto W8-1
)

:W8-1
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-08] C:\check\w1~82/log.txt 파일을 확인하고 하드디스크 기본 공유를 제거하시오 >> C:\check\w1~82/Action.txt
echo 시작-실행-FSMGMT.MSC-공유-기본공유선택-마우스 우클릭-공유 중지 >> C:\check\w1~82/Action.txt

del log.txt

rem #################################################################
reg query "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "autoshare" >> C:\check\w1~82/log.txt
reg query "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "autoshare" >> reg.txt

type reg.txt | find "0x0"
if %errorlevel% EQU 0 (
	echo B^|[W-08] 하드디스크 기본 공유 레지스트리 값 0 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-08] 하드디스크 기본 공유 레지스트리 값 0 아님 - [취약] >> C:\check\w1~82/inspect.txt
	goto W8-2
)

:W8-2
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-08] 하드디스크 기본 공유 레지스트리 값 0으로 변경하십시오 >> C:\check\w1~82/Action.txt
echo 시작-실행-REGEDIT >> C:\check\w1~82/Action.txt
echo 아래 레지스트리 값을 0으로 수정 (키값이 없을 경우 새로 생성) >> C:\check\w1~82/Action.txt
echo “HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer” >> C:\check\w1~82/Action.txt

del reg.txt

rem #################################################################
echo [W-09] 불필요한 서비스 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-09] 불필요한 서비스 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt

echo B^|[W-09] 일반적으로 불필요한 서비스(아래 목록 참고)가 구동 중인 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-09]C:\check\w1~82/log.txt 파일을 확인하고 불필요한 서비스 제거하세요(가이드 내 표 참고) >> C:\check\w1~82/Action.txt
echo 시작-실행-SERVICES.MSC-‘해당 서비스’선택-속성, 시작 유형-사용안함, 서비스 상태-중지설정으로 불필요한 서비스 중지 >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-10] IIS서비스 구동 점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-10] IIS서비스 구동 점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start >> [W-10]log.txt

type [W-10]log.txt | find /i "IIS ADMIN Service" >nul 2>&1
if %errorlevel% EQU 0 (
	echo B^|[W-10] IIS서비스가 필요하지 않지만 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-10] 담당자와 상의 후 IIS 서비스가 불필요할 시 >> C:\check\w1~82/Action.txt
	echo 시작-실행-SERVICE.MSC-IISADMIN-속성-시작 유형을 사용 안함 설정 후 중지로 IIS 서비스 중지 >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-10] IIS서비스가 필요하지 않아 이용하지 않는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del [W-10]log.txt

rem #################################################################
echo [W-11] 디렉토리 리스팅 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-11] 디렉토리 리스팅 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\inetpub\wwwroot\web.config | find /i "directoryBrowse" >> C:\check\w1~82/log.txt
type C:\inetpub\wwwroot\web.config | find /i "directoryBrowse" > inform.txt

type inform.txt | find /i "false"
if %errorlevel% equ 0 (
	echo B^|[W-11] 디렉토리 검색이 사용 안 함으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-11] 디렉토리 검색이 사용으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-11] 제어판-관리도구-인터넷정보서비스 IIS관리-해당 웹 사이트-IIS-디렉토리 검색 선택-사용 안함 선택 >> C:\check\w1~82/Action.txt
)

del inform.txt

rem #################################################################
echo [W-12-1] IIS CGI 실행 제한(scripts 존재여부)
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-12-1] IIS CGI 실행 제한(scripts 존재여부) ^#^#^#^#^# >> C:\check\w1~82/log.txt

dir C:\inetpub /b >> C:\check\w1~82/log.txt
dir C:\inetpub /b > [W-12-1]log.txt

type [W-12-1]log.txt | find /I "scripts" > nul
if %errorlevel% EQU 0 (
	echo B^|[W-12-1] 해당 디렉토리에 scripts 파일이 존재할경우 설정값 - [취약] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-12-1] scripts 파일이 존재하지 않는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del [W-12-1]log.txt

rem #################################################################
:W12-1
echo [W-12-2] IIS CGI 실행 제한
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-12-2] IIS CGI 실행 제한 ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\inetpub\scripts | findstr /i "EVERYONE" >> C:\check\w1~82/log.txt
icacls C:\inetpub\scripts | findstr /i "EVERYONE" > [W-12-2]log.txt

type [W-12-2]log.txt | findstr /i "W M F"
if %errorlevel% EQU 0 (
	echo B^|[W-12-2] 해당 디렉토리 Everyone에 모든 권한, 수정 권한, 쓰기 권한이 부여되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-12-2] 탐색기-해당 디렉토리-속성-보안-Everyone의 모든 권한, 수정 권한, 쓰기 권한 제거 >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-12-2] 해당 디렉토리 Everyone에 모든 권한, 수정 권한, 쓰기 권한이 부여되지 않은 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del [W-12-2]log.txt


rem #################################################################
echo [W-13] IIS 상위 디렉토리 접근 금지
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-13] IIS 상위 디렉토리 접근 금지 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config > [W-13]log.txt

type [W-13]log.txt | find /I "enableParentPaths" | find /i "false" > log.txt
if errorlevel 0 goto W13B
if not errorlevel 0 goto W13G

:W13B
	echo B^|[W-13] 상위 디렉토리 접근 기능을 제거하지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-13] 제어판-관리도구-인터넷 정보서비스(IIS) 관리자-해당 웹사이트-IIS-ASP 선택-부모경로 사용 항목-False 설정 >> C:\check\w1~82/Action.txt
	goto W13

:W13G
	echo B^|[W-13] 상위 디렉토리 접근 기능을 제거한 경우 - [양호] >> C:\check\w1~82/inspect.txt
	goto W13

:W13
del[W-13]log.txt
del log.txt


rem #################################################################
echo [W-14] IIS 불필요한 파일 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-14] IIS 불필요한 파일 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt


echo B^|[W-14] 해당 웹 사이트에 IIS Samples, IIS Help 가상디렉토리가 존재하는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-14] IIS 7.0(Windows 2008) 이상 버전 해당사항 없음 >> C:\check\w1~82/Action.txt
echo [W-14] Windows 2000, 2003의 경우 Sample 디렉토리 확인 후 삭제 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-15] 웹 프로세스 권한 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-15] 웹 프로세스 권한 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-15] 웹 프로세스가 관리자 권한이 부여된 계정으로 구동되고 있는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-15] 시작 - 제어판 - 관리도구 - 컴퓨터 관리 - 로컬 사용자 및 그룹 - 사용자 선택 - nobody 계정 추가 >> C:\check\w1~82/Action.txt
echo [W-15] 시작 - 제어판 - 관리도구 - 로컬 보안 정책 - 사용자 권한 할당 선택, " 서비스 로그온" 에 "nobody" 계정 추가 >> C:\check\w1~82/Action.txt
echo [W-15] 시작 - 실행 - SERVICES.MSC - IIS Admin Service - 속성 - [로그온] 탭의 계정 지정에 nobody 계정 및 패스워드 >> C:\check\w1~82/Action.txt
echo [W-15] 시작 - 프로그램 - 윈도우 탐색기 - IIS가 설치된 폴더 속성 - [보안] 탭에서 nobody 계정을 추가하고 모든 권한 체크 >> C:\check\w1~82/Action.txt
echo.>> C:\check\w1~82/Action.txt
echo.[W-15] 추가사항 >> C:\check\w1~82/Action.txt
echo [W-15] "웹사이트 등록정보" - 홈 디렉토리 - 응용프로그램 보호(iis 프로세스 권한 설정 ) >> C:\check\w1~82/Action.txt
echo [W-15] 높음 ,보통 ,낮음 중 낮음으로 되어있는 경우 >> C:\check\w1~82/Action.txt
echo [W-15] IIS 프로세스는 시스템 권한을 가지게 되므로 해커가 IIS 프로세스의 권한을 획득하면 관리자에 준하는 권한을 가질 수 있으므로 주의 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-16] IIS 링크 사용금지
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-16] IIS 링크 사용금지 ^#^#^#^#^# >> C:\check\w1~82/log.txt

set file=C:\inetpub\wwwroot

for /f "tokens=*" %%a in ('dir %file% /S /B') do echo %%a >> C:\check\w1~82/log.txt
WHERE /r C:\inetpub\wwwroot *.htm *.url *.html
if %errorlevel% EQU 0 (
	echo B^|[W-16] 심볼릭 링크, aliases, 바로가기 등의 사용을 허용함 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-16] 등록된 웹 사이트의 홈 디렉토리에 있는 심볼릭 링크, aliases, 바로가기 파일을 삭제하십시오. >> C:\check\w1~82/Action.txt
	echo 제어판-시스템 및 보안-관리도구-IIS관리자-해당 웹사이트-기본 설정-"실제 경로"에서 홈 디렉토리 위치 확인 >> C:\check\w1~82/Action.txt
	echo 실제 경로에 입력된 홈 디렉토리로 이동하여 바로가기 파일을 삭제 >> C:\check\w1~82/Action.txt
)	else (
	echo B^|[W-16] 심볼릭 링크, aliases, 바로가기 등의 사용을 허용하지 않음 - [양호] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-17] IIS 파일 업로드 및 다운로드 제한
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-17] IIS 파일 업로드 및 다운로드 제한 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\inetpub\wwwroot\web.config | findstr /I "maxAllowedContentLength" >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config | findstr /I "bufferingLimit maxRequestEntityAllowed" >> C:\check\w1~82/log.txt
echo B^|[W-17] 웹 프로세스의 서버 자원을 관리하지 않는 경우 (업로드 및 다운로드 용량 미 제한) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo IIS 7버전 이상에서는 기본값으로 컨텐츠용량 31457280byte(30MB), 다운로드 4194304byte(4MB), 업로드 200000byte(0.2MB)로 제한하고 있습니다. >> C:\check\w1~82/Action.txt
echo 등록된 웹 사이트의 루트 디렉토리에 있는 web.config 파일 내 security 아래에 다음 항목을 추가하세요. >> C:\check\w1~82/Action.txt
echo ^<requestFiltering^> >> C:\check\w1~82/Action.txt
echo     ^<requestLimits maxAllowedContentLength="컨텐츠용량" /^> >> C:\check\w1~82/Action.txt
echo ^<requestFiltering^> >> C:\check\w1~82/Action.txt
echo - >> C:\check\w1~82/Action.txt
echo %systemroot% \system32\inetsrv\config\applicationHost.config 파일 내 ^<asp/^>와 ^<asp^>사이에 다음 항목 추가 >> C:\check\w1~82/Action.txt
echo ^<limits bufferingLimit="파일다운로드용량" maxRequestEntityAllowed="파일업로드용량" /^> >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-18] IIS DB 연결 취약점 점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-18] IIS DB 연결 취약점 점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\inetpub\wwwroot\web.config | findstr /I "path="*."" >> pathSite.txt
type C:\inetpub\wwwroot\web.config | findstr /I "fileExtension" >> filterSite.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config | findstr /I "path="*."" >> pathServer.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config | findstr /I "fileExtension" >> filterServer.txt
type pathSite.txt | findstr /I "*.asa *.asax" >> C:\check\w1~82/log.txt
type filterSite.txt | findstr /I "asa asax" >> C:\check\w1~82/log.txt
type pathServer.txt | findstr /I "*.asa *.asax" >> C:\check\w1~82/log.txt
type filterServer.txt | findstr /I "asa asax" >> C:\check\w1~82/log.txt

type pathServer.txt | findstr /I "*.asa *.asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] 서버 "처리기매핑"의 사용 항목에 asa, asax가 등록되어 있지 않습니다. - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] 서버 "처리기매핑"의 사용항목에 asa, asax가 등록되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS관리자-해당서버- IIS-"처리기 매핑"선택-사용 항목에 *.asa 및 *.asax를 삭제하세요. >> C:\check\w1~82/Action.txt
)

type filterServer.txt | find /I "true" | findstr /I "asa asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] 서버 "요청 필터링"의 asa, asax 확장자가 false로 설정되어 있습니다. - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] 서버 "요청 필터링"의 asa, asax 확장자가 true로 설정되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS관리자-해당서버-IIS-"요청 필터링"선택-asa 및 asax 확장자를 false로 설정하세요. >> C:\check\w1~82/Action.txt
)

type pathSite.txt | findstr /I "*.asa *.asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] 사이트 "처리기매핑"의 사용 항목에 asa, asax가 등록되어 있지 않습니다. - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] 사이트 "처리기매핑"의 사용항목에 asa, asax가 등록되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS관리자-해당 웹 사이트- IIS-"처리기 매핑"선택-사용 항목에 *.asa 및 *.asax를 삭제하세요. >> C:\check\w1~82/Action.txt
)

type filterSite.txt | find /I "true" | findstr /I "asa asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] 사이트 "요청 필터링"의 asa, asax 확장자가 false로 설정되어 있습니다. - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] 사이트 "요청 필터링"의 asa, asax 확장자가 true로 설정되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS관리자-해당 웹 사이트-IIS-"요청 필터링"선택-asa 및 asax 확장자를 false로 설정하세요. >> C:\check\w1~82/Action.txt
)

del pathSite.txt
del filterSite.txt
del pathServer.txt
del filterServer.txt


rem #################################################################
echo [W-19] IIS 가상 디렉토리 삭제
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-19] IIS 가상 디렉토리 삭제 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-19] 해당 웹 사이트에 IIS Admin, IIS Adminpwd 가상 디렉토리가 존재하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-19] Windows 2003(6.0) 이상 버전 해당 사항 없음 >> C:\check\w1~82/Action.txt
echo Windows 2000(5.0) >> C:\check\w1~82/Action.txt
echo 시작-실행-INETMGR 입력-웹 사이트- IISAdmin, IISAdminpwd 선택-삭제 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-20] IIS 데이터 파일 ACL 적용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-20] IIS 데이터 파일 ACL 적용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls "C:\inetpub\wwwroot" >> C:\check\w1~82/log.txt

icacls "C:\inetpub\wwwroot" | findstr /I "Everyone" > NUL
if %errorlevel% EQU 0 (
  echo B^|[W-20] 홈 디렉토리 내에 있는 하위 파일들에 대해 Everyone 권한이 존재 - [취약] >> C:\check\w1~82/inspect.txt
  echo.>> C:\check\w1~82/Action.txt
  echo [조치사항] >> C:\check\w1~82/Action.txt
  echo [W-20] 시작-실행-INETMGR 입력-사이트 클릭-해당 웹사이트-기본 설정- 홈 디렉토리 실제 경로 확인 >> C:\check\w1~82/Action.txt
  echo 탐색기를 이용하여 홈 디렉토리의 등록 정보-[보안]탭에서 Everyone 권한 확인 >> C:\check\w1~82/Action.txt
  echo 불필요한 Everyone 권한을 제거하십시오. >> C:\check\w1~82/Action.txt
)	else (
	echo B^|[W-20] 홈 디렉토리 내에 있는 하위 파일들에 대해 Everyone 권한이 존재하지 않음 - [양호] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-21] IIS Exec 명령어 쉘 호출 진단
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-21] IIS Exec 명령어 쉘 호출 진단 ^#^#^#^#^# >> C:\check\w1~82/log.txt

dir C:\Windows\System32\inetsrv /b >> C:\check\w1~82/log.txt
dir C:\Windows\System32\inetsrv /b > list.txt

echo.[W-21-1] detectlog >> C:\check\w1~82/Action.txt
type list.txt | findstr /i /l ".htr .IDC .stm .shtm .shtml .printer .htw .ida .idq htr.dll idc.dll stm.dll shtm.dll shtml.dll printer.dll htw.dll ida.dll idq.dll" >> C:\check\w1~82/Action.txt

echo.[W-21-1] listlog >> C:\check\w1~82/Action.txt
type list.txt | findstr /i /l ".htr .IDC .stm .shtm .shtml .printer .htw .ida .idq htr.dll idc.dll stm.dll shtm.dll shtml.dll printer.dll htw.dll ida.dll idq.dll" >> C:\check\w1~82/Action.txt
if errorlevel 1 goto W21G
if not errorlevel 1 goto W21B


:W21B
	echo B^|[W-21] htr IDC stm shtm shtml printer htw ida idq가 존재함 log에서 확인 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-21] 시작 - 실행 - INETMGR - 웹사이트 - 해당 웹사이트 - 처리기 매핑 선택 >> C:\check\w1~82/Action.txt
	echo [W-21] 취약한 매핑 제거 (htr idc stm shtm shtml printer htw ida idq) >> C:\check\w1~82/Action.txt
	goto W21

:W21G
	echo B^|[W-21] htr IDC stm shtm shtml printer htw ida idq가 존재하지않음  - [양호] >> C:\check\w1~82/inspect.txt
	goto W21

:W21
del list.txt


rem #################################################################
echo [W-22-1] IIS Exec 명령어 쉘 호출 진단(레지스트리값 존재 유무)
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-22-1] IIS Exec 명령어 쉘 호출 진단(레지스트리값 존재 유무) ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters /s | find /v "오류" >> C:\check\w1~82/log.txt
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters /s | find /v "오류" > reg.txt
type reg.txt | find /I "SSIEnableCmdDirective" > NUL

if %errorlevel% EQU 1 (
	echo B^|[W-22] 레지스트리값이 존재하지 않거나 IIS 6.0버전인 경우 - [양호] >> C:\check\w1~82/inspect.txt
	goto W22
) else (
	echo B^|[W-22] 해당 레지스트리값이 존재함 - [취약] >> C:\check\w1~82/inspect.txt
	goto W22-1
)


rem #################################################################
:W22-1
echo [W-22] IIS Exec 명령어 쉘 호출 진단
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-22] IIS Exec 명령어 쉘 호출 진단 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type reg.txt | find /I "SSIEnableCmdDirective" > ssl.txt
type reg.txt | find /I "SSIEnableCmdDirective" >> C:\check\w1~82/log.txt

type ssl.txt | find "0x1"
if %errorlevel% EQU 1 (
	echo B^|[W-22-1] 레지스트리값이 0임  - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-22-1] 해당 레지스트리값이 1임 [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo 시작 - 실행 - REGEDIT - HKLM\SYSTEM\CurrentControlSet\Services\W32VC\Parameters 검색 >> C:\check\w1~82/Action.txt
	echo DWORD - SSIEnableCmdDirective 값을 찾아 값을 0으로 입력 >> C:\check\w1~82/Action.txt
)

:W22
del reg.txt
del ssl.txt


rem #################################################################
echo [W-23] IIS WebDAV 비활성화
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-23] IIS WebDAV 비활성화 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config > log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config >> C:\check\w1~82/log.txt

type log.txt | findstr /I "webdav.dll" | find "true"
if errorlevel 1 goto W23G
if not errorlevel 1 goto W23B

:W23B
echo B^|[W-23] WebDav가 존재함 - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-23] 인터넷 정보 서비스(IIS) 관리자 - 서버 선택 - IIS - ISAPI 및 CGI 제한 선택, WebDAV 사용여부 확인 (허용됨일 경우 취약) >> C:\check\w1~82/Action.txt
echo 인터넷 정보 서비스(IIS) 관리자 - 서버 선택 > IIS - "ISAPI 및 CGI 제한" 선택 WebDAV 항목 선택 - 작업에서 제거하거나, 편집 >> C:\check\w1~82/Action.txt
echo  - "확장 경로 실행 허용" 체크 해제 >> C:\check\w1~82/Action.txt
goto W23

:W23G
echo B^|[W-23] WebDav가 존재하지않음  - [양호] >> C:\check\w1~82/inspect.txt
goto W23


:W23
del log.txt


rem #################################################################
echo [W-24] NetBIOS 바인딩 서비스 구동 점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-24] NetBIOS 바인딩 서비스 구동 점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

wmic nicconfig where "TcpipNetbiosOptions<>null and ServiceName<>'VMnetAdapter'" get Description, TcpipNetbiosOptions >> C:\check\w1~82/log.txt
wmic nicconfig where "TcpipNetbiosOptions<>null and ServiceName<>'VMnetAdapter'" get Description, TcpipNetbiosOptions > netb.txt

type netb.txt | findstr /I "0" > NUL
if %errorlevel% EQU 0 (
	 echo B^|[W-24]  TCP/IP와 NetBIOS 간의 바인딩이 제거 되어 있음 [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-24] TCP/IP와 NetBIOS 간의 바인딩이 제거 되어있지 않음 [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-24] 시작 - 실행 - ncpa.cpl - 로컬 영역 연결 - 속성 - TCP/IP - [일반] 탭에서 [고급] 클릭 - [WINS] 탭에서 TCP/IP에서 "NetBIOS 사용 안 함" >> C:\check\w1~82/Action.txt
	echo [W-24] 또는, "NetBIOS over TCP/IP 사용 안 함" 선택 >> C:\check\w1~82/Action.txt
)

del netb.txt


rem #################################################################
echo [W-25] FTP 서비스 구동 점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-25] FTP 서비스 구동 점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start | find "Microsoft FTP Service" >> C:\check\w1~82/log.txt

net start | find "Microsoft FTP Service"
if %errorlevel% EQU 0 (
	echo B^|[W-25] FTP 서비스를 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
        echo [W-25] FTP 서비스가 불필요할 경우 FTP서비스 사용 중지 >> C:\check\w1~82/Action.txt
	echo 시작 - 실행 - SERVICES.MSC - FTP Publishing Service - 속성 - [일반] 탭에서 "시작 유형" 사용 안 함 으로 설정한 후, FTP 서비스 중지 >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-25] FTP 서비스를 사용하지 않는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-26] FTP 디렉토리 접근권한 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-26] FTP 디렉토리 접근권한 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\inetpub\ftproot >> C:\check\w1~82/log.txt

icacls C:\inetpub\ftproot | findstr /i "EVERYONE"
if %errorlevel% EQU 0 (
	echo B^|[W-26] FTP 홈 디렉토리에 Everyone 권한이 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-26] 인터넷 정보 서비스 IIS 관리 - FTP 사이트 - 해당 FTP 사이트 - 속성 - [홈 디렉토리] 탭에서 FTP 홈 디렉토리 확인 >> C:\check\w1~82/Action.txt
	echo [W-26] 탐색기 - 홈 디렉토리 - 속성 - [보안] 탭에서 Everyone 권한 제거 >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-26] 양호 FTP 홈 디렉토리에 Everyone 권한이 없는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-27] Anonymous FTP 금지
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-27] Anonymous FTP 금지 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config | find "anonymousAuthentication enabled" >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config | find "anonymousAuthentication enabled" > log.txt

type log.txt | find "true"
if %errorlevel% EQU 0 (
	echo B^|[W-27] FTP 익명 사용 허용됨 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-27] 제어판-관리도구-인터넷 정보 서비스 IIS 관리-해당 웹사이트-마우스 우클릭-FTP 게시 추가 >> C:\check\w1~82/Action.txt
	echo 이후 진행 과정에서 인증 화면의 익명 체크 박스 해제 >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-27] FTP 익명 사용자 허용 안함 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-28] FTP 접근 제어 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-28] FTP 접근 제어 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config | find /I "add ipAddress" >> C:\check\w1~82/log.txt

echo B^|[W-28] FTP 접근 제어 설정 확인(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-28] C:\check\w1~82/log.txt 파일을 확인하고 담당자와 상의하여 불필요한 주소의 접근을 제거 하십시오. >> C:\check\w1~82/Action.txt
echo 제어판-관리도구-인터넷 정보 서비스(IIS)관리-해당 웹사이트-FTP IPv4주소 및 도메인 제한 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-29] DNS Zone Transfer 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-29] DNS Zone Transfer 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start > log.txt

type log.txt | find "DNS Server"
if %errorlevel% EQU 1 (
	echo B^|[W-29] DNS서비스를 사용하지 않는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-29] DNS서비스를 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-29] DNS서비스를 중단하세요. >> C:\check\w1~82/Action.txt
)

reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find /I "SecureSecondaries" >> reg.txt

type reg.txt | findstr /I "0x1 0x2"
if %errorlevel% EQU 1 (
	echo B^|[W-29] 영역 전송 허용을 하지 않는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-29] 영역 전송 허용을 하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-29] W1~82\log\[W-29]log.txt 파일을 확인하여 'SecureSecondaries' 레지스트리값이 0x0이거나 >> C:\check\w1~82/Action.txt
	echo [W-29] 0x3이 아닌 항목의 영역 전송 설정 변경 >> C:\check\w1~82/Action.txt
	echo [W-29] 시작-실행-DNSMGMT.MSC-각 조회 영역-해당 영역-속성-영역 전송 >> C:\check\w1~82/Action.txt
	echo [W-29] “다음 서버로만” 선택후 전송할 서버 IP 추가 >> C:\check\w1~82/Action.txt
)

del log.txt
del reg.txt


rem #################################################################
echo [W-30] RDS (Remote Data Services)제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-30] RDS (Remote Data Services)제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s >> C:\check\w1~82/log.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s >> log.txt

type log.txt | findstr "ADCLaunch"
if errorlevel EQU 0(
	echo B^|[W-30] RDS(Remote Data Services) 제거됨 (2008 이상 양호) >> C:\check\w1~82/inspect.txt
	goto W30
) else (
	echo B^|[W-30] RDS(Remote Data Services) 제거됨 (2008 미만 취약) >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-30] 시작-실행-inetmgr-웹사이트 선택 후 오른쪽 디렉토리에서 msadc제거 >> C:\check\w1~82/Action.txt
	echo 다음의 레지스트리 키/디렉토리 제거 >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch\RDSServer.DataFactory >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch\AdvancedDataFactory >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch\VbBusObj.VbBusObjCls >> C:\check\w1~82/Action.txt
	goto W30
)

:W30
del log.txt


rem #################################################################
echo [W-31] 최신 서비스팩 적용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-31] 최신 서비스팩 적용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-31] 최신 서비스팩이 설치되지 않거나, 적용 절차 및 방법이 수립되지 않은 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-31] 시작-실행-Winver입력-서비스팩 버전 확인 후 최신 버전이 아닌 경우 >> C:\check\w1~82/Action.txt
echo "https://support.microsoft.com/ko-kr/lifecycle/search"에서 최신 서비스팩 다운로드 후 설치 또는 자동업데이트를 활용해주세요. >> C:\check\w1~82/Action.txt
echo ※인터넷 웜이 Windows의 취약점을 이용하여 공격하기 때문에 서비스팩 설치시에는 네트워크와 분리된 상태에서 설치 할 것을 권장합니다.※ >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-32] 최신 HOT FIX 적용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-32] 최신 HOT FIX 적용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo C^|[W-32] 최신 HotFix가 있는지 주기적으로 모니터 절차가 없거나, 최신 HotFix를 반영하지 않은 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo C^|[W-32] 또한 PMS(Patch Management System) Agent가 설치되어 있지 않거나, 설치되어 있으나 자동패치배포가 적용되지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo 수동 HOT FIX 적용 방법 >> C:\check\w1~82/Action.txt
echo "https://technet.microsoft.com/ko-kr/security/"에서 패치 리스트를 조회하여, 서버에 필요한 패치를 선별하여 수동으로 설치 >> C:\check\w1~82/Action.txt
echo. >> C:\check\w1~82/Action.txt
echo 자동 HOT FIX 적용 >> C:\check\w1~82/Action.txt
echo Windows 자동 업데이트 기능을 이용한 설치 >> C:\check\w1~82/Action.txt
echo 제어판-windows update >> C:\check\w1~82/Action.txt
echo. >> C:\check\w1~82/Action.txt
echo PMS설치 >> C:\check\w1~82/Action.txt
echo Agent를 설치하여 자동으로 업데이트 되도록 설정함 >> C:\check\w1~82/Action.txt
echo ※ 보안패치 및 Hot Fix 경우 적용 후 시스템 재시작을 요구하는 경우가 대부분이므로 관리자는 서비스에 지장이 없는 시간대에 적용할 것. >> C:\check\w1~82/Action.txt
echo ※ 일부 Hot Fix는 수행되고있는 OS 프로그램이나 개발용 Application 프로그램에 영향을 줄 수 있으므로 패치 적용 전 >> C:\check\w1~82/Action.txt
echo Application 프로그램을 구분하고, 필요하다면 OS 벤더 또는 Application 엔지니어에게 확인 작업을 거친 후 패치를 수행할 것. >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-33] 백신 프로그램 업데이트
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-33] 백신 프로그램 업데이트 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo C^|[W-33] log 파일을 보고 백신 프로그램이 최신 엔진 업데이트가 설치되어 있는지 확인해주세요.(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt

echo 바이로봇 >> C:\check\w1~82/log.txt
reg query "HKLM\software\hauri" /s >> C:\check\w1~82/log.txt
reg query hklm\software\hauri\virobot /s | findstr /i "state" >> C:\check\w1~82/log.txt

echo 안랩 V3 >> C:\check\w1~82/log.txt
reg query hklm\software\ahnlab /s | findstr /i "v3" | findstr /v /i "filter" >> C:\check\w1~82/log.txt
reg query hklm\software\ahnlab /s >> W1~82\log\[W-33]log.txt
reg query hklm\software\ahnlab /s | findstr /i "productname company autoupdateuse v3enginedate version UseSmartUpdate sysmonuse" >> C:\check\w1~82/log.txt

echo 트랜드마이크로 >> C:\check\w1~82/log.txt
reg query "hklm\software\trendmicro" /s >> C:\check\w1~82/log.txt
reg query "hklm\software\trendmicro" /s | findstr /i "patterndate" >> C:\check\w1~82/log.txt

echo 포어 프런트 >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft forefront" /s >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft forefront" /s | findstr /i "productupdate updatesearch" | findstr /i /v "fail loca" >> C:\check\w1~82/log.txt

echo Microsoft security Essentials >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft Antimalware" /s  >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft Antimalware" /s | findstr /i "SignaturesLastUpdated" >> C:\check\w1~82/log.txt


rem #################################################################
echo [W-34] 로그의 정기적 검토 및 보고
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-34] 로그의 정기적 검토 및 보고 ^#^#^#^#^# >> C:\check\w1~82/log.txt

wevtutil qe Application /f:text >> C:\check\w1~82/log.txt
wevtutil qe Security /f:text >> C:\check\w1~82/log.txt
wevtutil qe Setup /f:text >> C:\check\w1~82/log.txt
wevtutil qe System /f:text >> C:\check\w1~82/log.txt

echo D^|[W-34] 로그 기록에 대해 정기적으로 검토, 분석, 리포트 작성 및 보고 등의 조치가 이루어 지지 않는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo 접속기록 등의 보안 로그, 응용프로그램 로그, 시스템 로그기록에 대해 정기적으로 검토, 분석, 리포트 작성 및 보고하십시오. >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-35] 원격으로 액세스 할 수 있는 레지스트리 경로
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-35] 원격으로 액세스 할 수 있는 레지스트리 경로 ^#^#^#^#^# >> C:\check\w1~82/log.txt

sc query RemoteRegistry >> C:\check\w1~82/log.txt

sc query RemoteRegistry | FIND "STOPPED"
if %errorlevel% EQU 0 (
	echo D^|[W-35] Remote Registry Service가 중지되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo D^|[W-35] Remote Registry Service를 사용 중 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-35] Remote Registry Service를 중지해야합니다. >> C:\check\w1~82/Action.txt
	echo 시작-실행-SERVICES.MSC 입력-Remote Registry-속성 >> C:\check\w1~82/Action.txt
	echo 시작 유형을 사용 안 함, 서비스 상태를 중지로 바꿔주십시오. >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-36] 백신 프로그램 설치
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-36] 백신 프로그램 설치 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start > [W-36]log.txt

type [W-36]log.txt | findstr /i "Alyac Ahnlab Hauri Symantec Trendmicro"
if %errorlevel% EQU 0 (
	echo E^|[W-36] 백신프로그램이 설치되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-36] 백신프로그램이 설치되어 있지 않음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-36] 관리 담당자를 통해 바이러스 백신 프로그램이 반드시 설치하여야 하도록 함 >> C:\check\w1~82/Action.txt
)

del [W-36]log.txt


rem #################################################################
echo [W-37] SAM 파일 접근 통제 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-37] SAM 파일 접근 통제 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\windows\system32\config\SAM >> C:\check\w1~82/log.txt

icacls C:\windows\system32\config\SAM > log.txt
type log.txt | findstr /I "%COMPUTERNAME% Everyone"
if errorlevel 1 goto W37G
if not errorlevel 1 goto W37B

:W37G
echo E^|[W-37] SAM 파일 접근권한에 Administrator, System 그룹만 모든 권한으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
goto W37

:W37B
echo E^|[W-37] SAM 파일 접근권한에 Administrator, System 그룹 외 다른 그룹에 권한이 설정되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-37] c:windows\system32\config\SAM 속성 보안 찾아 들어가기 >> C:\check\w1~82/Action.txt
echo [W-37] Administrator, System 그룹 외 다른 사용자 및 그룹권한 제거 >> C:\check\w1~82/Action.txt
goto W37

:W37
del log.txt


rem #################################################################
echo [W-38] 화면 보호기 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-38-1] 화면 보호기 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo [화면보호기 활성화 여부]
reg query "HKCU\Control Panel\Desktop" /v ScreenSaveActive > ScreenSaveActive.txt
reg query "HKCU\Control Panel\Desktop" /v ScreenSaveActive >> C:\check\w1~82/log.txt
for /f "tokens=3" %%a in (ScreenSaveActive.txt) do set ScreenSaveActive=%%a
if %ScreenSaveActive% EQU 0 (
	echo E^|[W-38-1] 화면 보호기가 설정되지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-38-1] 제어판-디스플레이-화면보호기 변경 찾아 들어가기-화면 보호기 활성화 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-38-1] 화면 보호기가 설정된 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del ScreenSaveActive.txt

echo E^|[W-38-1] 화면 보호기가 설정되지 않은 경우(레지스트리값이 업데이트 되지 않을 수 있기에 수동 점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-38-1] 제어판-디스플레이-화면보호기 변경 찾아 들어가기-화면 보호기 활성화 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-38-2] 화면 보호기 암호화 사용 여부
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-38-2] 화면 보호기 암호화 사용 여부 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure > ScreenSaverIsSecure.txt
reg query "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure >> C:\check\w1~82/log.txt
for /f "tokens=3" %%a in (ScreenSaverIsSecure.txt) do set ScreenSaverIsSecure=%%a
if %ScreenSaverIsSecure% EQU 0 (
	echo E^|[W-38-2] 화면 보호기 암호화를 사용하지 않은 경우  - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-38-2] 제어판-디스플레이-화면보호기 변경 찾아 들어가기-화면 보호기 암호사용 설정 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-38-2] 화면 보호기 암호화를 사용하는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del ScreenSaverIsSecure.txt


rem #################################################################
echo [W-38-3] 화면 보호기 대기시간 10분 미만 값 설정 여부
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-38-3] 화면 보호기 대기시간 10분 미만 값 설정 여부 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut > ScreenSaveTimeOut.txt
reg query "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut >> C:\check\w1~82/log.txt
for /f "tokens=3" %%a in (ScreenSaveTimeOut.txt) do set ScreenSaveTimeOut=%%a
if %ScreenSaveTimeOut% LEQ 600 (
	echo E^|[W-38-3] 화면 보호기 대기 시간이 10분 미만의 값으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo E^|[W-38-3] 화면 보호기 대기 시간이 10분을 초과한 값으로 설정되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-38-3] 제어판-디스플레이-화면보호기 변경 찾아 들어가기 >> C:\check\w1~82/Action.txt
	echo [W-38-3] 화면보호기 활성화-다시 시작할 때 로그온 화면표시 체크-대기시간 10분 설정 >> C:\check\w1~82/Action.txt
)

del ScreenSaveTimeOut.txt


rem #################################################################
echo [W-39] 로그온 하지 않고 시스템 종료 허용 해제
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-39] 로그온 하지 않고 시스템 종료 허용 해제 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /s | find /I "shutdownwithoutlogon" > log.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /s | find /I "shutdownwithoutlogon" >> C:\check\w1~82/log.txt

type log.txt | find /I "shutdownwithoutlogon    REG_DWORD    0x1" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-39] 로그온 하지 않고 시스템 종료 허용이 사용 안함으로 설정되어 있지 않음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-39] 시작-실행-SECPOL.MSC-로컬정책-보안옵션 찾아 들어가기 >> C:\check\w1~82/Action.txt
	echo [W-39] 시스템 종료 - 로그온 하지 않고 시스템 종료 허용을 사용 안함으로 설정 >> C:\check\w1~82/Action.txt
  del log.txt
) else (
	echo E^|[W-39] 로그온 하지 않고 시스템 종료 허용이 사용 안함으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
  del log.txt
)


rem #################################################################
echo [W-40] 원격 시스템에서 강제로 시스템 종료
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-40] 원격 시스템에서 강제로 시스템 종료 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\check\w1~82/log.txt
echo E^|[W-40] 원격 시스템에서 강제로 시스템 종료 정책에 Administrators 외 다른 계정 및 그룹이 존재하는 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-40] 시작-실행-SECPOL.MSC-로컬정책-사용자 권한 할당 찾아 들어가기 >> C:\check\w1~82/Action.txt
echo 원격 시스템에서 강제로 시스템 종료 정책에 Administrators 외 다른 계정 및 그룹이 존재할 경우 담당자와 함께 확인 후 제거 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-41] 보안 감사를 로그할 수 없는 경우 즉시 시스템 종료 해제
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-41] 보안 감사를 로그할 수 없는 경우 즉시 시스템 종료 해제 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "CrashOnAuditFail" | find "0" > NUL
if %errorlevel% EQU  0 (
	echo E^|[W-41] "사용 안 함"으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-41] "사용"으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-41] 시작-실행-SECPOL.MSC-로컬정책 - 보안옵션 “감사: 보안 감사를 로그할 수 없는 경우 즉시 시스템 종료” 정책을 “사용 안 함” 으로 설정 >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-42-1] SAM 계정과 공유의 익명 열거 허용 안 함
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-42-1] SAM 계정과 공유의 익명 열거 허용 안 함 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "RestrictAnonymous" | find "4,1" > NUL
if %errorlevel% EQU 0 (
	echo E^|[W-42-1] SAM 계정과 공유의 익명 열거 허용 안 함 정책 '사용'으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-42-1] SAM 계정과 공유의 익명 열거 허용 안 함 정책 '사용 안 함'으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-42-1] 시작-실행-SECPOL.MSC-로컬정책 - 보안옵션 '네트워크 액세스 : SAM 계정과 공유의 익명 열거 허용 안 함' 으로 설정 >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-42-2] SAM 계정의 익명 열거 허용 안 함
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-42-2] SAM 계정의 익명 열거 허용 안 함 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "RestrictAnonymousSAM" | find "1" > NUL
if %errorlevel% EQU 0 (
	echo E^|[W-42-2] SAM 계정의 익명 열거 허용 안 함 정책 '사용'으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-42-2] SAM 계정의 익명 열거 허용 안 함 정책 '사용 안 함'으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-42-2] 시작-실행-SECPOL.MSC-로컬정책 - 보안옵션 '네트워크 액세스 :SAM 계정의 익명 열거 허용 안 함'에 '사용' 선택 >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-43] IIS Exec 명령어 쉘 호출 진단
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-43] IIS Exec 명령어 쉘 호출 진단 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s >> C:\check\w1~82/log.txt
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "autoadminlogon" > reg.txt

type reg.txt | findstr "1" > NUL
if %errorlevel% EQU 0 (
	echo E^|[W-43] 해당 레지스트리값이 1임 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo 시작 - 실행 - REGEDIT - HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon 검색 >> C:\check\w1~82/Action.txt
	echo DWORD - AutoAdminLogon  값을 찾아 값을 0으로 입력 >> C:\check\w1~82/Action.txt
	echo DefaultPassword 엔트리가 존재한다면 삭제 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-43] 레지스트리값이 존재하지않거나 값이 0임 - [양호] >> C:\check\w1~82/inspect.txt
)

del reg.txt


rem #################################################################
echo [W-44] 이동식 미디어 포맷 및 꺼내기 허용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-44] 이동식 미디어 포맷 및 꺼내기 허용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "AllocateDASD" | find "0"
if %errorlevel% EQU  0 (
	echo E^|[W-44] - 양호 : “이동식 미디어 포맷 및 꺼내기 허용” 정책이 “Administrator”로 되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-44] 이동식 미디어 포맷 및 꺼내기 허용” 정책이 “Administrator”로 되어 있지 않은 경우 또는 설정이 안되어있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-44] 시작 - 실행 - SECPOL.MSC - 로컬정책 - 보안옵션  “장치 : 이동식 미디어 포맷 및 꺼내기 허용” 정책을 “Administrators” 로 설정 >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-45] 디스크볼륨 암호화 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-45] 디스크볼륨 암호화 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo E^|[W-45] "데이터 보호를 위해 내용을 암호화" 정책이 선택되어 있지 않은 경우(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-45] 비인가자 접근 통제가 반드시 필요한 디렉터리에 대해서만 암호화 처리 >> C:\check\w1~82/Action.txt
echo [W-45] 폴더 선택 - 속성 -  [일반] 탭 - 고급 - 고급 특성 - “데이터 보호를 위해 내용을 암호화” 선택 >> C:\check\w1~82/Action.txt
echo [W-45] ※ 폴더 속성 - [보안] 탭에서 허가된 사용자 외에는 폴더 내 파일 접근 불가함 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-46] Everyone 사용 권한을 익명 사용자에게 적용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-46] Everyone 사용 권한을 익명 사용자에게 적용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg log.txt
secedit /export /cfg C:\check\w1~82/log.txt

type log.txt | find /i "EveryonIncludesAnonymous"
if %errorlevel% EQU 0 (
	echo A^|[W-46] 'Everyone 사용 권한을 익명 사용자에게 적용' 정책이 '시용 안 함'으로 되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-46] 'Everyone 사용 권한을 익명 사용자에게 적용' 정책이 '사용'으로 되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-46] 시작-실행-SELPOL.MSC-로컬정책-보안옵션 >> C:\check\w1~82/Action.txt
	echo [W-46] 'Everyone 사용 권한을 익명 사용자에게 적용' 정책이 '시용 안 함' 으로 설정 >> C:\check\w1~82/Action.txt
)

del log.txt


rem #################################################################
echo [W-47] 계정 잠금 기간 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-47] 계정 잠금 기간 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /i "잠금 기간 (분):" > log.txt
net accounts | find /i "잠금 기간 (분):" >> C:\check\w1~82/log.txt

type log.txt | find /i "잠금 기간 (분):"
for /f "tokens=4" %%a in (log.txt) do set log=%%a
if %log% LSS 60 (
	echo A^|[W-47]  계정 잠금 기간 및 잠금 기간 원래대로 설정 기간 이 설정되지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-47] 시작-실행-SELPOL.MSC-계정 정책-계정 잠금 정책 >> C:\check\w1~82/Action.txt
	echo [W-47] 계정 잠금 기간 다음 시간 후 계정 잠금 수를 원래대로 설정 에 대해 각각 ‘60분’ 설정 >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-47] 계정 잠금 기간 및 ‘계정 잠금 기간 원래대로 설정 기간 이 설정되어 있는 경우 60분 이상의 값으로 설정하기를 권고함 - [양호] >> C:\check\w1~82/inspect.txt
)

net accounts | find /i "잠금 관찰 창 (분):" > log.txt
net accounts | find /i "잠금 관찰 창 (분):" >> C:\check\w1~82/log.txt

type log.txt | find /i "잠금 관찰 창 (분):"
for /f "tokens=4" %%a in (log.txt) do set log=%%a
if %log% LSS 60 (
	echo A^|[W-47]  계정 잠금 기간 및 잠금 기간 원래대로 설정 기간 이 설정되지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-47] 시작-실행-SELPOL.MSC-계정 정책-계정 잠금 정책 >> C:\check\w1~82/Action.txt
	echo [W-47] 계정 잠금 기간 다음 시간 후 계정 잠금 수를 원래대로 설정 에 대해 각각 ‘60분’ 설정 >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-47] 계정 잠금 기간 및 ‘계정 잠금 기간 원래대로 설정 기간 이 설정되어 있는 경우 60분 이상의 값으로 설정하기를 권고함 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-48] 패스워드 복잡성 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-48] 패스워드 복잡성 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg log.txt
secedit /export /cfg C:\check\w1~82/log.txt

type log.txt | find /i "PasswordComplexity"
if %errorlevel% EQU 0 (
	echo A^|[W-48] '암호 복잡성을 만족해야 함' 정책이 '사용 안 함'으로 되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-48] 시작-실행-SECPOL.MSC-계정 정책-암호 정책 >> C:\check\w1~82/Action.txt
	echo [W-48] '암호는 복잡성을 만족해야함'을 사용으로 설정 >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-48] '암호 복잡성을 만족해야 함' 정책이 '사용'으로 되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-49] 패스워드 최소 암호 길이
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-49] 패스워드 최소 암호 길이 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /i "최소 암호 길이:" > log.txt
net accounts | find /i "최소 암호 길이:" >> C:\check\w1~82/log.txt

type log.txt | find /i "최소 암호 길이:"
for /f "tokens=4" %%a in (log.txt) do set log=%%a
if %log% LSS 8 (
	echo A^|[W-49] 최소 암호 길이가 설정되지 않았거나 8문자 미만으로 설정되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-49] 시작-실행-SECPOL.MSC-계정정책-암호정책 >> C:\check\w1~82/Action.txt
	echo [W-49] 최소 암호 길이를 8문자로 설정 >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-49] 최소 암호 길이가 8문자 이상으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-50] 패스워드 최대 사용 기간
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-50] 패스워드 최대 사용 기간 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /i "최대 암호 사용 기간 (일):" > log.txt
net accounts | find /i "최대 암호 사용 기간 (일):" >> C:\check\w1~82/log.txt

type log.txt | find /i "최대 암호 사용 기간 (일):"
for /f "tokens=6" %%a in (log.txt) do set log=%%a
if %log% GTR 90 (
	echo A^|[W-50] 최대 암호 사용 기간이 설정되지 않았거나 90일을 초과하는 값으로 설정된 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-50] 시작-실행-SECPOL.MSC-계정정책-암호정책 >> C:\check\w1~82/Action.txt
	echo [W-50] ‘최대 암호 사용 기간’의 다음 이후 암호 만료 기간을 ‘90일’로 설정 >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-50] 최대 암호 사용 기간이 90일 이하로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-51] 패스워드 최소 사용 기간
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-51] 패스워드 최소 사용 기간 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find "최소 암호 사용 기간" > minpw.txt
net accounts | find "최소 암호 사용 기간" >> C:\check\w1~82/log.txt

for /f "tokens=6" %%a in (minpw.txt) do set minpw=%%a
if %minpw% gtr 0 (
	echo A^|[W-51] 최소 암호 사용 기간이 0보다 큼 - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo A^|[W-51] 최소 암호 사용 기간이 0으로 설정되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-51] 시작-실행-SECPOL.MSC 입력-계정정책-암호정책 >> C:\check\w1~82/Action.txt
	echo 최소암호사용기간을 1일 이상으로 설정하십시오.※권장 1일※ >> C:\check\w1~82/Action.txt
)

del minpw.txt


rem #################################################################
echo [W-52] 마지막 사용자 이름 표시 안 함
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-52] 마지막 사용자 이름 표시 안 함 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\value.txt
type C:\value.txt | find "DontDisplayLastUserName" > display.txt
type C:\value.txt | find "DontDisplayLastUserName" >> C:\check\w1~82/log.txt

for /f "delims=, tokens=2" %%a in (display.txt) do set result=%%a
if %result% EQU 1 (
	echo A^|[W-52] "마지막 사용자 이름 표시 안 함"이 "사용"으로 설정되어 있습니다. - [양호] >> C:\check\w1~82/inspect.txt
	del C:\value.txt
	del display.txt
)	else (
	echo A^|[W-52] "마지막 사용자 이름 표시 안 함"이 "사용 안 함"으로 설정되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-52] 시작-실행-SECPOL.MSC 입력-로컬정책-보안옵션 >> C:\check\w1~82/Action.txt
	echo [W-52] "대화형 로그온: 마지막 사용자 이름 표시 안 함"을 "사용"으로 설정하십시오. >> C:\check\w1~82/Action.txt
	del C:\value.txt
	del display.txt
)


rem #################################################################
echo [W-53] 로컬 로그온 허용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-53] 로컬 로그온 허용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\value.txt

type C:\value.txt | find /i "SeInteractiveLogonRight" >> C:\check\w1~82/log.txt
echo A^|[W-53] 로컬 로그온 허용 정책"에 Administrator, IUSR 외 다른 계정 및 그룹이 존재하면 안됩니다.(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-53] 시작-실행-SECPOL.MSC입력-로컬정책-사용자권한할당-"로컬 로그온 허용"정책 확인 후 Administrator, IUSR 외의 계정을 제거하십시오. >> C:\check\w1~82/Action.txt

del C:\value.txt


rem #################################################################
echo [W-54] 익명 SID/이름 변환 허용 해제
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-54] 익명 SID/이름 변환 허용 해제 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\inform.txt
type C:\inform.txt | find /I "LSAAnonymousNameLookup" > Anonymous.txt
type C:\inform.txt | find /I "LSAAnonymousNameLookup" >> C:\check\w1~82/log.txt

for /f "tokens=3" %%a in (Anonymous.txt) do set result=%%a
if %result% EQU 0 (
	echo A^|[W-54] '익명 SID/이름 변환 허용'정책이 '사용 안 함'으로 되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
	del C:\inform.txt
	del Anonymous.txt
)	else (
	echo A^|[W-54] '익명 SID/이름 변환 허용'정책이 '사용'으로 되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-54] '네트워크 액세스:익명 SID/이름 변환 허용'정책을 '사용 안 함'으로 설정해야합니다. >> C:\check\w1~82/Action.txt
	echo 시작-실행-SECPOL.MSC입력-로컬정책-보안옵션 >> C:\check\w1~82/Action.txt
	echo '네트워크 액세스: 익명 SID/이름 변환 허용' 정책을 '사용 안 함'으로 설정 >> C:\check\w1~82/Action.txt
	del C:\inform.txt
	del Anonymous.txt
)


rem #################################################################
echo [W-55] 최근 암호 기억
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-55] 최근 암호 기억 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /I "암호 기록" >> uniquepw.txt
net accounts | find /I "암호 기록" >> C:\check\w1~82/log.txt

for /f "tokens=4" %%a in (uniquepw.txt) do set result=%%a
if %result% GEQ 4 (
	echo A^|[W-55] 최근 암호 기억이 4개 이상으로 설정되어 있음 - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo A^|[W-55] 최근 암호 기억이 4개 미만으로 설정되어 있음 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-55] 최근 암호 기억을 4개 이상으로 설정하십시오. >> C:\check\w1~82/Action.txt
	echo 시작-실행-SECPOL.MSC입력-계정정책-암호정책 >> C:\check\w1~82/Action.txt
	echo '최근 암호 기억'을 4개 이상으로 설정 >> C:\check\w1~82/Action.txt
)

del uniquepw.txt


rem #################################################################
echo [W-56] 콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-56] 콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /EXPORT /CFG LocalSecurityPolicy.txt

type LocalSecurityPolicy.txt | find /i "LimitBlankPasswordUse=" >> C:\check\w1~82/log.txt

type LocalSecurityPolicy.txt | find /i "LimitBlankPasswordUse=" | find "4,1" > NUL
if %errorlevel% EQU 0 (
 echo A^|[W-56] "콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한" 정책이 "사용"으로 설정됨 - [양호] >> C:\check\w1~82/inspect.txt
)
if not %errorlevel% EQU 0 (
 echo A^|[W-56] "콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한" 정책이 "사용 안함"으로 설정됨 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-56] 시작 - 실행 - secpol.msc - 로컬 정책 - 보안 옵션 >> C:\check\w1~82/Action.txt
 echo [W-56] "계정 : 콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한" 정책을 "사용"으로 설정 >> C:\check\w1~82/Action.txt
)

del LocalSecurityPolicy.txt


rem #################################################################
echo [W-57] 원격터미널 접속 가능한 사용자 그룹 제한
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-57] 원격터미널 접속 가능한 사용자 그룹 제한 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections > reg.txt
type reg.txt | find /I "0x0" > NUL

if %errorlevel% EQU 0 (
 echo A^|[W-57] "이 컴퓨터에 대한 원격 연결" 설정이 "허용" 으로 설정됨 - [양호] [추가적인 점검 필요, 조치사항 참고] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-57] 제어판 - 사용자 계정 - 관리자 계정 이외의 계정 생성 >> C:\check\w1~82/Action.txt
 echo [W-57] 제어판 - 시스템 - 원격 설정 - [원격] 탭 - [원격 데스크톱] 메뉴 >> C:\check\w1~82/Action.txt
 echo [W-57] "사용자 선택" 에서 원격 사용자 지정 후 확인 >> C:\check\w1~82/Action.txt
) else (
 echo A^|[W-57] "이 컴퓨터에 대한 원격 연결" 설정이 "허용 안 함" 으로 설정됨 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-57] 제어판 - 사용자 계정 - 관리자 계정 이외의 계정 생성 >> C:\check\w1~82/Action.txt
 echo [W-57] 제어판 - 시스템 - 원격 설정 - [원격] 탭 - [원격 데스크톱] 메뉴 >> C:\check\w1~82/Action.txt
 echo [W-57] "이 컴퓨터에 대한 원격 연결 허용"에 체크 - "사용자 선택" 에서 원격 사용자 지정 후 확인 >> C:\check\w1~82/Action.txt
)

del reg.txt


rem #################################################################
echo [W-58] 터미널 서비스 암호화 수준 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-58] 터미널 서비스 암호화 수준 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel > reg.txt
type reg.txt | findstr "0x0 0x1"

if %errorlevel% EQU 0 (
 echo B^|[W-58] 터미널 서비스를 사용하고, 암호화 수준이 "낮음"으로 설정됨 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-58] 시작 - 실행 - REGEDIT >> C:\check\w1~82/Action.txt
 echo "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" >> C:\check\w1~82/Action.txt
 echo "MinEncryptionLevel" 값을 "2(중간)"이상으로 설정 >> C:\check\w1~82/Action.txt
)
if not %errorlevel% EQU 0 (
 echo B^|[W-58] 터미널 서비스를 사용하지 않거나, 사용 시 암호화 수준이 "클라이언트와 호환가능(중간)이상"으로 설정됨 - [양호] >> C:\check\w1~82/inspect.txt
)

del reg.txt


rem #################################################################
echo [W-59] IIS 웹서비스 정보 숨김
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-59] IIS 웹서비스 정보 숨김 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config >> C:\check\w1~82/log.txt
type W1~82\log\[W-59]log.txt | find /i "httpErrors errorMode" > iisweb.txt

type iisweb.txt | find /i "custom"
if %errorlevel% EQU 0 (
	echo B^|[W-59] 웹 서비스 에러 페이지가 별도로 지정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-59] 웹 서비스 에러 페이지가 별도로 지정되지 않아 에러 발생 시 중요 정보 가 노출되는 경우- [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-59] 제어판- 관리 도구- IIS[인터넷 정보 서비스] 관리자- 해당 웹 사이트- [오류 페이지] >> C:\check\w1~82/Action.txt
	echo [작업] 탭에서 [기능 설정 편집] - 서버 오류 발생 시 다음 반환 항목을 사용자 지정 오류 페이지로 설정 >> C:\check\w1~82/Action.txt
)

del iisweb.txt


rem #################################################################
echo [W-60] SNMP 서비스 구동점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-60] SNMP 서비스 구동점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start | find /I "SNMP Service" > nul

if %errorlevel% EQU 0 (
	echo B^|[W-60] SNMP 서비스를 사용하지 않는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-60] SNMP 서비스를 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-60] 시작-실행-SERVICES.MSC-SNMP Service 속성-"시작 유형"을 "사용 안함"으로 설정-SNMP 서비스 중지 >> C:\check\w1~82/Action.txt
)

del log.txt


rem #################################################################
echo [W-61] SNMP 서비스 커뮤니티스트링의 복잡성 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-61] SNMP 서비스 커뮤니티스트링의 복잡성 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" > log.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" >> C:\check\w1~82/log.txt

type log.txt | findstr /I "public private" >nul
if errorlevel 1 goto W61G
if not errorlevel 1 goto W61B

:W61G
echo B^|[W-61] SNMP 서비스를 사용하지 않거나, Community String이 public, private이 아닌 경우 - [양호] >> C:\check\w1~82/inspect.txt

:W61B
echo B^|[W-61] SNMP 서비스를 사용하며, Community String이 public, private인 경우  - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-61] 시작-실행-SERVICES.MSC-SNMP Service 속성-보안-[인증 트랩 보내기] 앞 체크박스 해제 또는 [받아들인 커뮤니티 이름]에서 public, private 제거 >> C:\check\w1~82/Action.txt

del log.txt


rem #################################################################
echo [W-62] SNMP Access control 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-62] SNMP Access control 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" | find /i "EnableAuthenticationTraps" > inform.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" >> C:\check\w1~82/log.txt

type inform.txt | find /i "0x1"
if %errorlevel% equ 0 (
	echo B^|[W-62-1] "인증 트랩 보내기"에 체크가 되어있습니다. - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-62-1] "인증 트랩 보내기"에 체크가 되어있지 않습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-62-1] ^<인증 트랩 보내기^> >> C:\check\w1~82/Action.txt
	echo 시작-실행-SERVICES.MSC 입력-SNMP Service-속성-보안-"인증 트랩 보내기"에 체크해주세요 >> C:\check\w1~82/Action.txt
)

del inform.txt


rem #################################################################
echo [W-62] SNMP Access control 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-62] SNMP Access control 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" > inform2.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" >> C:\check\w1~82/log.txt

type inform2.txt | find /i "1"
if %errorlevel% equ 0 (
	echo B^|[W-62-2] "특정 호스트로부터 SNMP 패킷 받아들이기"로 설정되어 있습니다. - [양호] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-62-2] "모든 호스트로부터 SNMP 패킷 받아들이기"로 설정되어 있습니다. - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-62-2] ^<특정 호스트로부터 SNMP 패킷 받아들이기 설정법^> >> C:\check\w1~82/Action.txt
	echo 시작-실행-SERVICES.MSC 입력-SNMP Service-속성-보안 >> C:\check\w1~82/Action.txt
	echo "다음 호스트로부터 SNMP 패킷 받아들이기" 체크 후 밑에 추가 버튼을 눌러 호스트를 지정해주세요 >> C:\check\w1~82/Action.txt
)

del inform2.txt


rem #################################################################
echo [W-63] DNS 서비스 구동점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-63] DNS 서비스 구동점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt

net start | find "DNS Server"
if %errorlevel% EQU 1 (
echo B^|[W-63] DNS 서비스를 사용하지 않거나, 동적 업데이트가 "없음"으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
echo B^|[W-63] DNS 서비스를 사용하며, 동적 업데이트가 설정되어 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-63] 시작-실행-DNSMGMT.MSC-각 조회 영역-해당 영역-속성-일반-동적 업데이트-없음 선택 >> C:\check\w1~82/Action.txt
)

del log.txt


rem #################################################################
echo [W-64] HTTP/FTP/SMTP 배너 차단
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-64] HTTP/FTP/SMTP 배너 차단  ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config  >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config > logsu.txt
type logsu.txt | findstr /i "suppressDefaultBanner" | find "true"
if %errorlevel% EQU 0 (
	echo B^|[W-64-1] FTP, 접속 시 배너 정보가 보이지 않는 경우 - [양호]  >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-64-1] FTP 접속 시 배너를 사용하는 경우 - [취약]  >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-64-1] IIS 인터넷 정보 서비스 관리자 - FTP 메시지 - 기본 배너 숨기기 설정 >> C:\check\w1~82/Action.txt
)

del logsu.txt


rem #################################################################
echo [W-64] HTTP/FTP/SMTP 배너 차단
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-64] HTTP/FTP/SMTP 배너 차단 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-64S] HTTP 헤더 확인 필요.(관리자 직접점검) - [취약]  >> C:\check\w1~82/inspect.txt
echo B^|[W-64S] SMTP 헤더 확인 필요.(관리자 직접점검) - [취약]  >> C:\check\w1~82/inspect.txt

echo.>> C:\check\w1~82/Action.txt
echo [HTTP 조치사항] >> C:\check\w1~82/Action.txt
echo Microsoft 다운로드 센터에서 URL Rewrite 다운로드 후 설치 https://www.iis.net/downloads/microsoft/url-rewrite >> C:\check\w1~82/Action.txt
echo. >> C:\check\w1~82/Action.txt
echo 제어판 - 관리도구 - IIS[인터넷 정보 서비스] 관리자 - 해당 웹 사이트 - [URL 재작성] >> C:\check\w1~82/Action.txt
echo 작업 탭 - [서버 값 관리 - 서버 변수 보기...] >> C:\check\w1~82/Action.txt
echo 작업 탭 - [추가...]- 서버 변수 추가- 서버 변수 이름: RESPONSE_SERVER >> C:\check\w1~82/Action.txt
echo [URL 재작성] - 작업 탭 - [규칙 추가...] - 아웃바운드 규칙 - 빈 규칙 >> C:\check\w1~82/Action.txt
echo 이름, 검색 범위, 변수 이름, 패턴 설정 - 적용- 이름(N): Remove Server - 검색 범위: 서버 변수- 변수 이름: RESPONSE_SERVER- 패턴 T: .* >> C:\check\w1~82/Action.txt

echo.>> C:\check\w1~82/Action.txt
echo [SMTP 조치사항] >> C:\check\w1~82/Action.txt
echo 시작 - 실행 - cmd - adsutil.vbs 파일이 있는 디렉터리로 이동- 명령어: cd C:\inetpub\AdminScripts- adsutil.vbs를 사용하기 위해 서버 관리자에서 역할 추가 필요 >> C:\check\w1~82/Action.txt
echo [웹 서버IIS-관리 도구- IIS 6 관리 호환성- IIS 6 스크립팅 도구] 설치 필요 >> C:\check\w1~82/Action.txt
echo IIS에서 서비스 중인 SMTP 서비스 목록 확인- 명령어: cscript adsutil.vbs enum /p smtpsvc >> C:\check\w1~82/Action.txt
echo SMTP 서비스에 connectresponse 속성 값에서 배너 문구 수정- 명령어: cscript adsutil.vbs set smtpsvc/1/connectresponse “Banner Text >> C:\check\w1~82/Action.txt
echo SMTP 서비스 재시작- 명령어: net stop smtpsvc 중지- 명령어: net start smtpsvc 시작 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-65] Telnet 보안 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-65] Telnet 보안 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start  >> C:\check\w1~82/log.txt
net start  >> 65log.txt
type 65log.txt | find /I "Telnet"
if %errorlevel% EQU 1 (
	echo B^|[W-65-1] Telnet Service 미 구동중 - [양호]  >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-65-1] Telnet Service 구동중 - [취약]  >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-65-1] 불필요 시 해당 서비스 제거 - 시작 - 실행 - SERVICES.MSC - Telnet = 속성 [일반] 탭에서 "시작 유형"을 "사용 안 함"으로 설정한 후 Telnet 서비스 중지 >> C:\check\w1~82/Action.txt
)

del 65log.txt


rem #################################################################
echo  [W-66] 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-66] 불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-66] 사용하지 않는 불필요한 ODBC 데이터 소스 제거(관리자 직접점검) - [취약]  >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-66] 시작 - 설정 - 제어판 - 관리 도구 - ODBC 데이터 원본 - 시스템 DSN - 해당 드라이브 클릭 >> C:\check\w1~82/Action.txt
echo 사용하지 않는 데이터 소스 제거 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-67] 공유 권한 및 사용자 그룹 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-67] 공유 권한 및 사용자 그룹 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | find /I "MaxIdleTime" > 67log.txt
type 67log.txt | find /I "MaxIdleTime" | find /I 1800000
if %errorlevel% EQU 0 (
	echo B^|[W-67] 원격제어 시 Timeout 제어 설정이 적용되어 30분으로 설정된 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-67] 원격제어 시 Timeout 제어 설정을 적용하지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-67] 시작 - 실행 - GPEDIT.MSC[로컬 그룹 정책 편집기] >> C:\check\w1~82/Action.txt
	echo  컴퓨터 구성 - 관리 템플릿 - Windows 구성 요소 - 터미널 서비스 - 원격 데스크톱세션 호스트 - 세션 시간 제한 >> C:\check\w1~82/Action.txt
	echo  [활성 상태지만 유휴 터미널 서비스 세션에 시간제한 설정] - [유휴 세션 제한]을 30분으로 설정 >> C:\check\w1~82/Action.txt
)

del 67log.txt


rem #################################################################
echo [W-68] 예약된 작업에 의심스러운 명령이 등록되어 있는지 점검
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-68] 예약된 작업에 의심스러운 명령이 등록되어 있는지 점검 ^#^#^#^#^# >> C:\check\w1~82/log.txt

schtasks >> C:\check\w1~82/log.txt
echo B^|[W-68] 불필요한 명령어나 파일 등 주기적인 예약 작업의 존재 여부를 직접 점검 필요(관리자 직접점검) -[취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-68] GUI 확인 방법 - 제어판 - 관리도구 - 작업 스케줄러에서 확인 등록된 예약 작업을 선택하여 상세내역 확인 불필요한 파일 존재 시 삭제 >> C:\check\w1~82/Action.txt
echo CLI의 경우 [W-68]log.txt 참조 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg LocalSecurityPolicy.txt
type LocalSecurityPolicy.txt | findstr /i "AuditSystemEvents AuditLogonEvents AuditObjectAccess AuditPrivilegeUse AuditPolicyChange AuditAccountManage AuditProcessTracking AuditDSAccess AuditAccountLogon" > log.txt
type LocalSecurityPolicy.txt | findstr /i "AuditSystemEvents AuditLogonEvents AuditObjectAccess AuditPrivilegeUse AuditPolicyChange AuditAccountManage AuditProcessTracking AuditDSAccess AuditAccountLogon" >> C:\check\w1~82/log.txt
type log.txt | findstr /i "AuditSystemEvents" > SystemEvents.txt

for /f "tokens=3" %%a in (SystemEvents.txt) do set SystemEvents=%%a
if %SystemEvents% == 3 (
 echo C^|[W-69-1] 시스템 이벤트 감사 - [양호]  >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-1] 시스템 이벤트 감사 - [취약]  >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-1] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-1] "시스템 이벤트 감사" 항목 "성공,실패"로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditLogonEvents" > LogonEvents.txt

for /f "tokens=3" %%a in (LogonEvents.txt) do set LogonEvents=%%a
if %LogonEvents% == 3 (
 echo C^|[W-69-2] 로그온 이벤트 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-2] 로그온 이벤트 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-2] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-2] "로그온 이벤트 감사" 항목 "성공,실패"로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditObjectAccess" > ObjectAccess.txt

for /f "tokens=3" %%a in (ObjectAccess.txt) do set ObjectAccess=%%a
if %ObjectAccess% == 0 (
 echo C^|[W-69-3] 개체 액세스 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-3] 개체 액세스 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-3] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-3] "개체 액세스 감사" 항목 "감사 안 함"으로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditPrivilegeUse" > PrivilegeUse.txt

for /f "tokens=3" %%a in (PrivilegeUse.txt) do set PrivilegeUse=%%a
if %PrivilegeUse% == 0 (
 echo C^|[W-69-4] 권한 사용 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-4] 권한 사용 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-4] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-4] "권한 사용 감사" 항목 "감사 안 함"으로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditPolicyChange" > PolicyChange.txt

for /f "tokens=3" %%a in (PolicyChange.txt) do set PolicyChange=%%a
if %PolicyChange% == 1 (
 echo C^|[W-69-5] 정책 변경 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-5] 정책 변경 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-5] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-5] "정책 변경 감사" 항목 "성공"으로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditAccountManage" > AccountManage.txt

for /f "tokens=3" %%a in (AccountManage.txt) do set AccountManage=%%a
if %AccountManage% == 1 (
 echo C^|[W-69-6] 계정 관리 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-6] 계정 관리 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-6] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-6] "계정 관리 감사" 항목 "성공"으로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditProcessTracking" > ProcessTracking.txt

for /f "tokens=3" %%a in (ProcessTracking.txt) do set ProcessTracking=%%a
if %ProcessTracking% == 0 (
 echo C^|[W-69-7] 프로세스 추적 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-7] 프로세스 추적 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-7] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-7] "프로세스 추적 감사" 항목 "감사 안 함"으로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditDSAccess" > DSAccess.txt

for /f "tokens=3" %%a in (DSAccess.txt) do set DSAccess=%%a
if %DSAccess% == 1 (
 echo C^|[W-69-8] 디렉토리 서비스 액세스 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-8] 디렉토리 서비스 액세스 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-8] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-8] "디렉토리 서비스 액세스 감사" 항목 "성공"으로 설정 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] 정책에 따른 시스템 로깅 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] 정책에 따른 시스템 로깅 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditAccountLogon" > AccountLogon.txt

for /f "tokens=3" %%a in (AccountLogon.txt) do set AccountLogon=%%a
if %AccountLogon% == 1 (
 echo C^|[W-69-9] 계정 로그온 이벤트 감사 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-9] 계정 로그온 이벤트 감사 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-69-9] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 감사 정책 >> C:\check\w1~82/Action.txt
 echo [W-69-9] "계정 로그온 이벤트 감사" 항목 "성공"으로 설정 >> C:\check\w1~82/Action.txt
)

del SystemEvents.txt LogonEvents.txt ObjectAccess.txt PrivilegeUse.txt PolicyChange.txt
del AccountManage.txt ProcessTracking.txt DSAccess.txt AccountLogon.txt
del log.txt LocalSecurityPolicy.txt


rem #################################################################
echo [W-70] 이벤트 로그 관리 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-70] 이벤트 로그 관리 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

wevtutil gl security >> C:\check\w1~82/log.txt
wevtutil gl security > test.txt
type test.txt | find /i "maxSize" > size.txt

for /f "tokens=2" %%a in (size.txt) do set size=%%a
if %size% gtr 10480000 (
	echo D^|[W-70] 최대 로그 크기 "10,240KB 이상"으로 설정하였습니다 - [양호] [추가조치 필요, 조치사항 참고] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-70] Default가 아닌 다른 로그는 직접확인해야합니다. >> C:\check\w1~82/Action.txt
	echo [W-70] ^<Default가 아닌 다른 로그 확인법^> >> C:\check\w1~82/Action.txt
	echo 시작-실행-EVENTVWR.MSC입력-해당로그-속성-일반 >> C:\check\w1~82/Action.txt
	echo 최대 로그 크기를 10,240 이상으로 설정해주세요 >> C:\check\w1~82/Action.txt
) else (
	echo D^|[W-70] 최대 로그 크기 "10,240KB 미만"으로 설정하였습니다 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-70] 최대 로그 크기 지정 >> C:\check\w1~82/Action.txt
	echo 시작-실행-EVENTVWR.MSC입력-해당로그-속성-일반 >> C:\check\w1~82/Action.txt
	echo 최대 로그 크기를 10,240 이상으로 설정해주세요 >> C:\check\w1~82/Action.txt
	echo [W-70] Default가 아닌 다른 로그는 직접확인해야합니다 >> C:\check\w1~82/Action.txt
	echo [W-70] ^<Default가 아닌 다른 로그 확인법^> >> C:\check\w1~82/Action.txt
	echo 시작-실행-EVENTVWR.MSC입력-해당로그-속성-일반 >> C:\check\w1~82/Action.txt
	echo 최대 로그 크기를 10,240 이상으로 설정해주세요 >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-70] 이벤트 로그 관리 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-70] 이벤트 로그 관리 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type test.txt | find /i "retention" >> oldlog.txt
type test.txt | find /i "autoBackup" >> oldlog.txt

type oldlog.txt | find /i "true"
if %errorlevel% equ 0 (
	echo D^|[W-70-1]"필요한 경우 이벤트 덮어쓰기"에 체크가 안되어있습니다 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-70-1] 최대 로그 크기 도달 시 설정 >> C:\check\w1~82/Action.txt
	echo 시작-실행-EVENTVWR.MSC입력-해당로그-속성-일반 >> C:\check\w1~82/Action.txt
	echo "필요한 경우 이벤트 덮어쓰기"에 체크해주세요. >> C:\check\w1~82/Action.txt
	echo [W-70]"필요한 경우 이벤트 덮어쓰기"에 체크해주세요. >> C:\check\w1~82/Action.txt
) else (
	echo D^|[W-70-1] "필요한 경우 이벤트 덮어쓰기"에 체크되어 있습니다 - [양호] >> C:\check\w1~82/inspect.txt
)

del oldlog.txt
del test.txt
del size.txt


rem #################################################################
echo [W-71] 원격에서 이벤트 로그 파일 접근 차단
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# W-71] 원격에서 이벤트 로그 파일 접근 차단 ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\Windows\System32\LogFiles > inform.txt
icacls C:\Windows\System32\LogFiles >> C:\check\w1~82/log.txt

type inform.txt | find /i "everyone"
if %errorlevel% equ 0 (
	echo D^|[W-71] 로그 디렉토리의 접근권한에 Everyone 권한이 있습니다 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-71] 탐색기-로그 디렉토리-속성-보안_ Everyone 제거 >> C:\check\w1~82/Action.txt
) else (
	echo D^|[W-71] 로그 디렉토리의 접근권한에 Everyone 권한이 있습니다 - [양호] >> C:\check\w1~82/inspect.txt
)

del inform.txt

rem #################################################################
echo [W-72] DoS 공격 방어 레지스트리 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-72] DoS 공격 방어 레지스트리 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters > dos.txt
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters >> C:\check\w1~82/log.txt
type dos.txt | findstr /i "SynAttackProtect EnableDeadGWDetect KeepAliveTime NoNameReleaseOnDemand" >> inform.txt

type inform.txt | find /i "SynAttackProtect" | findstr /i "1 2"
if %errorlevel% equ 0 (
	echo E^|[W-72-1] SynAttackProtect - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-72-1] SynAttackProtect - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-72-1] 시작-실행-REGEDIT입력 >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters 검색 >> C:\check\w1~82/Action.txt
	echo 레지스트리 이름 : SynAttackProtect / 레지스트리 값 종류 : REG_DWORD / 유효 범위 : 0, 1, 2 / 권장 설정 값 : 1 또는 2로 설정 >> C:\check\w1~82/Action.txt
	echo 만약 레지스트리가 없으면 추가해주세요 >> C:\check\w1~82/Action.txt
)

del dos.txt
del inform.txt

rem #################################################################
echo [W-73] 사용자가 프린터 드라이버를 설치할 수 없게 함
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-73] 사용자가 프린터 드라이버를 설치할 수 없게 함 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\ControlSet001\Control\Print\Providers\LanMan Print Services\Servers" > log.txt
reg query "HKLM\SYSTEM\ControlSet001\Control\Print\Providers\LanMan Print Services\Servers" >> C:\check\w1~82/log.txt
type log.txt | find /I "AddPrinterDrivers" > log1.txt

type log1.txt | find /I "0x0" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-73] 사용자가 프린터 드라이버를 설치할 수 없게 함 정책이 사용 안함인 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-73] 시작-실행-SECPOL.MSC-로컬정책-보안옵션-[장치] 사용자가 프린터 드라이버를 설치할 수 없게함 - 정책을 사용으로 설정 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-73] 사용자가 프린터 드라이버를 설치할 수 없게 함 정책이 사용으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt
del log1.txt

rem #################################################################
echo [W-74] 세션 연결을 중단하기 전에 필요한 유휴시간
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-74] 세션 연결을 중단하기 전에 필요한 유휴시간 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" > log.txt
reg query "HKLM\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" >> C:\check\w1~82/log.txt

type log.txt | find /I "enableforcedlogoff    REG_DWORD    0x0" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-74-1] 로그온 시간이 만료되면 클라이언트 연결 끊기 정책이 사용 안함으로 설정되어 있을 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-74-1] 시작-실행-SECPOL.MSC-로컬정책-보안옵션-로그온 시간이 만료되면 클라이언트 연결 끊기- 정책을 사용 안함으로 설정 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-74-1] 로그온 시간이 만료되면 클라이언트 연결 끊기 정책이 사용으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

rem #################################################################
echo [W-74] 세션 연결을 중단하기 전에 필요한 유휴시간
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-74] 세션 연결을 중단하기 전에 필요한 유휴시간 ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | find /I "autodisconnect    REG_DWORD    0xffffffff" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-74-2] 세션 연결을 중단하기 전에 필요한 유휴 시간 정책이 15분으로 설정되어 있지 않을 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-74-2] 시작-실행-SECPOL.MSC-로컬정책-보안옵션-세션 연결을 중단하기 전에 필요한 유휴 시간-정책을 15분으로 설정 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-74-2] 세션 연결을 중단하기 전에 필요한 유휴 시간 정책이 15분으로 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt

rem #################################################################
echo [W-75] 경고 메시지 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-75] 경고 메시지 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" >> C:\check\w1~82/log.txt

echo E^|[W-75] 로그인 경고 메시지 제목 및 내용이 설정되어 있지 않은 경우, log 파일을 보고 관리자와 함께 직접확인 요망(관리자 직접점검) - [취약] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-75] 시작-실행-SECPOL.MSC-로컬정책-보안옵션-로그온 시도하는 사용자에 대한 메시지 제목(legalnoticecaption) - 배너 제목입력 >> C:\check\w1~82/Action.txt
echo [W-75] 시작-실행-SECPOL.MSC-로컬정책-보안옵션-로그온 시도하는 사용자에 대한 메시지 텍스트(legalnoticetext) - 배너 내용입력 >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-76] 사용자별 홈 디렉토리 권한 설정
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-76] 사용자별 홈 디렉토리 권한 설정 ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls "c:\users\Administrator" > log.txt
icacls "c:\users\Administrator" >> C:\check\w1~82/log.txt

type log.txt | find /i "everyone" > nul
if %errorlevel% EQU 0 (
 echo E^|[W-76] 홈 디렉토리에 Everyone 권한이 있는 경우 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-76] 홈C:\사용자\[사용자 계정] >> C:\check\w1~82/Action.txt
 echo [W-76] "All Users, Default USer"에 대한 권한 외 일반계정 삭제 >> C:\check\w1~82/Action.txt
) else (
 echo E^|[W-76] 홈 디렉토리에 Everyone 권한이 없는 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt

rem #################################################################
echo [W-77] LAN Manager 인증 수준
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-77] LAN Manager 인증 수준 ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /EXPORT /CFG LocalSecurityPolicy.txt
type LocalSecurityPolicy.txt | find /i "LmCompatibilityLevel" >> C:\check\w1~82/log.txt
type LocalSecurityPolicy.txt | find /i "LmCompatibilityLevel=4,3" > nul

if %errorlevel% EQU 0 (
 echo E^|[W-77] "LAN Manager 인증 수준" 정책에 "NTLMv2 응답만 보냄" 이 설정되어 있는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
 echo E^|[W-77] "LAN Manager 인증 수준" 정책에 "NTLMv2 응답만 보냄" 이 설정되어 있지 않은 경우 - [취약] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [조치사항] >> C:\check\w1~82/Action.txt
 echo [W-77] 시작 - 실행 - SECPOL.MSC - 로컬 정책 - 보안 옵션 >> C:\check\w1~82/Action.txt
 echo [W-77] "네트워크 보안 : LAN Manager 인증 수준" 정책에 "NTLMv2 응답만 보냄" 설정 >> C:\check\w1~82/Action.txt
)

del LocalSecurityPolicy.txt

rem #################################################################
echo [W-78] 보안 채널 데이터 디저털 암호화 또는 서명
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-78] 보안 채널 데이터 디저털 암호화 또는 서명 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" >> C:\check\w1~82/log.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "requiresignorseal" >> logre.txt

type logre.txt | findstr /I "0x1"
if %errorlevel% EQU 0 (
	echo E^|[W-78-1] 도메인 구성원: 보안 채널 데이터를 디지털 암호화 또는 서명 '사용' - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-78-1] 도메인 구성원: 보안 채널 데이터를 디지털 암호화 또는 서명 '사용 안 함' - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-78-1] 시작-실행-SECPOL.MSC-로컬 정책-보안 옵션 >> C:\check\w1~82/Action.txt
	echo [W-78-1] 도메인 구성원: 보안 채널 데이터를 디지털 암호화 또는 서명 정책 '사용'으로 설정 >> C:\check\w1~82/Action.txt
)

del logre.txt

rem #################################################################
echo [W-78] 보안 채널 데이터 디저털 암호화 또는 서명
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-78] 보안 채널 데이터 디저털 암호화 또는 서명 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "sealsecurechannel" >> logse.txt

type logsi.txt | findstr /I "0x1"
if %errorlevel% EQU 0 (
	echo E^|[W-78-2] 도메인 구성원: 보안 채널 데이터 디지털 서명 '사용' - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-78-2] 도메인 구성원: 보안 채널 데이터 디지털 서명 '사용 안 함' - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-78-2] 시작-실행-SECPOL.MSC-로컬 정책-보안 옵션 >> C:\check\w1~82/Action.txt
	echo [W-78-2] 도메인 구성원: 보안 채널 데이터 디지털 서명 정책 '사용'으로 설정 >> C:\check\w1~82/Action.txt
)

del logse.txt

rem #################################################################
echo [W-78] 보안 채널 데이터 디저털 암호화 또는 서명
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-78] 보안 채널 데이터 디저털 암호화 또는 서명 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "signsecurechannel" >> logsi.txt

type logse.txt | findstr /I "0x1"
if %errorlevel% EQU 0 (
	echo E^|[W-78-3] 도메인 구성원: 보안 채널 데이터 디지털 암호화 '사용' - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-78-3] 도메인 구성원: 보안 채널 데이터 디지털 암호화 '사용 안 함' - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-78-3] 시작-실행-SECPOL.MSC-로컬 정책-보안 옵션 >> C:\check\w1~82/Action.txt
	echo [W-78-3] 도메인 구성원: 보안 채널 데이터를 디지털 암호화 정책 '사용'으로 설정 >> C:\check\w1~82/Action.txt
)

del logsi.txt

rem #################################################################
echo [W-79] 파일 및 디렉토리 보호
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-1] 파일 및 디렉토리 보호 ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs c: >> C:\check\w1~82/log.txt
chkntfs c: >> logc.txt

type logc.txt | find /I "C: 드라이브가 없습니다."
if %errorlevel% EQU 0 (
	echo E^|[W-79-1] C드라이브가 없음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
goto W79C
)

:W79C
type logc.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-1] C드라이브가 NTFS 파일 시스템을 사용하는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-1] C드라이브가 FAT 파일 시스템을 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-79-1] 명령어 프롬프트[DOS창]에서 다음과 같이 입력 >> C:\check\w1~82/Action.txt
	echo [W-79-1] 시작 - 실행 - CMD - convert C: /fs:ntfs >> C:\check\w1~82/Action.txt
)

rem #################################################################
echo [W-79] 파일 및 디렉토리 보호
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-2] 파일 및 디렉토리 보호 ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs d: >> C:\check\w1~82/log.txt
chkntfs d: >> logd.txt

type logd.txt | find /I "D: 드라이브가 없습니다."
if %errorlevel% EQU 0 (
	echo E^|[W-79-2] D드라이브가 없음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
goto W79D
)

:W79D
type logd.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-2] D드라이브가 NTFS 파일 시스템을 사용하는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-2] D드라이브가 FAT 파일 시스템을 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-79-2] 명령어 프롬프트[DOS창]에서 다음과 같이 입력 >> C:\check\w1~82/Action.txt
	echo [W-79-2] 시작 - 실행 - CMD - convert D: /fs:ntfs >> C:\check\w1~82/Action.txt
)

rem #################################################################
echo [W-79] 파일 및 디렉토리 보호
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-3] 파일 및 디렉토리 보호 ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs e: >> C:\check\w1~82/log.txt
chkntfs e: >> loge.txt

type loge.txt | find /I "E: 드라이브가 없습니다."
if %errorlevel% EQU 0 (
	echo E^|[W-79-3] E드라이브가 없음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
goto W79E
)

:W79E
type loge.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-3] E드라이브가 NTFS 파일 시스템을 사용하는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-3] E드라이브가 FAT 파일 시스템을 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-79-3] 명령어 프롬프트[DOS창]에서 다음과 같이 입력 >> C:\check\w1~82/Action.txt
	echo [W-79-3] 시작 - 실행 - CMD - convert E: /fs:ntfs >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-79] 파일 및 디렉토리 보호
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-4] 파일 및 디렉토리 보호 ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs f: >> C:\check\w1~82/log.txt
chkntfs f: >> logf.txt

type logf.txt | find /I "F: 드라이브가 없습니다."
if %errorlevel% EQU 0 (
	echo E^|[W-79-4] F드라이브가 없음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
goto W79F
)

:W79GF
type logf.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-4] F드라이브가 NTFS 파일 시스템을 사용하는 경우 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-4] F드라이브가 FAT 파일 시스템을 사용하는 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-79] 명령어 프롬프트[DOS창]에서 다음과 같이 입력 >> C:\check\w1~82/Action.txt
	echo [W-79] 시작 - 실행 - CMD - convert F: /fs:ntfs >> C:\check\w1~82/Action.txt
)

del logc.txt
del logd.txt
del loge.txt
del logf.txt


rem #################################################################
echo [W-80] 컴퓨터 계정 암호 최대 사용 기간
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-80] 컴퓨터 계정 암호 최대 사용 기간 ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "DisablePasswordChange" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "DisablePasswordChange" > logd.txt

type logd.txt | find /I "0x0"
if %errorlevel% EQU 0 (
	echo E^|[W-80-1] '컴퓨터 계정 암호 변경 사용 안 함' 정책을 사용하지 않음 - [양호] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-80-1] '컴퓨터 계정 암호 변경 사용 안 함' 정책을 사용함 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-80-1] 시작-실행-SECPOL.MSC-로컬 정책-보안 옵션 >> C:\check\w1~82/Action.txt
	echo [W-80-1] 도메인 구성원: 컴퓨터 계정 암호 변경 사항 사용 안 함 → 사용 안 함 >> C:\check\w1~82/Action.txt
)

del logd.txt


rem #################################################################
echo [W-81] 시작프로그램 목록 분석
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-81] 시작프로그램 목록 분석 ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo "시작프로그램 목록" >> C:\check\w1~82/log.txt
dir "C:\Users\Administarator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >> C:\check\w1~82/log.txt
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" >> C:\check\w1~82/log.txt
echo. >> C:\check\w1~82/log.txt

echo "레지스트리 Run 목록" >> C:\check\w1~82/log.txt
echo "Windows x86 시작프로그램 목록" >> C:\check\w1~82/log.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> C:\check\w1~82/log.txt
echo. >> C:\check\w1~82/log.txt

echo "Windows x64 시작프로그램 목록" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" >> C:\check\w1~82/log.txt

echo E^|[W-81] 시작프로그램 목록을 정기적으로 검사하고 불필요한 서비스 체크 해제를 한 경우 (2012 서버 해당 없음) >> C:\check\w1~82/inspect.txt
echo E^|[W-81] 시작프로그램 목록을 정기적으로 검사하지 않고, 부팅 시 불필요한 서비스도 실행되고 있는 경우(관리자 직접점검) >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [조치사항] >> C:\check\w1~82/Action.txt
echo [W-81] 시작 - 검색 - msconfig 명령어 입력 >> C:\check\w1~82/Action.txt
echo [W-81] 시작 프로그램 탭 클릭 - 시작 프로그램 목록 중 불필요하거나 의심스러운 항목 체크 표시 해제 >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-82] Windows 인증 모드 사용
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-82] Windows 인증 모드 사용 ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start | find /I "SQL Server" >> log.txt

type log.txt | find /I "SQL Server"
if %errorlevel% EQU 0 (
	echo E^|[W-82] 'SQL Server'가 실행 중인 경우 - [취약] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [조치사항] >> C:\check\w1~82/Action.txt
	echo [W-82] SQL Server 서비스가 불필요할 경우 SQL Server 서비스 사용 중지 >> C:\check\w1~82/Action.txt
	echo [W-82] 시작 - 실행 - SERVICES.MSC - SQL Server - 속성 - [일반] 탭에서 "시작 유형" 사용 안 함 으로 설정한 후, SQL Server 서비스 중지 >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-82] 'SQL Server'가 실행 중이지 않은 경우 - [양호] >> C:\check\w1~82/inspect.txt
)

del log.txt

pause