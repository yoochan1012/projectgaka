@echo off
echo ---------------------------------------------�����켭�� ����� ����----------------------------------
echo 			         [W-01] ~ [W-82]������ �׸��� �����մϴ�.
echo.
echo Windows Server 2012 R2�� �������� ���۵� �ڵ��Դϴ�.���� ������ ���ؼ��� ������ �������� ���� ���� �� �ֽ��ϴ�.
echo bad�׸񿡼� ��ȣ �ڿ� S�� �ٴ� �׸��� ����ڿ� �����Ͽ� ���� �����ؾ��ϴ� �׸��Դϴ�.
echo bad�׸񿡼� ��ȣ �ڿ� SS�� ������ Windows Server 2012 ���� ���������� �ش��ϱ⿡ ���� �����ؾ� �ϴ� �׸��Դϴ�.

mkdir C:\check\w1~82

rem #################################################################
echo [W-01] Administrator ���� �̸� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#[W-01] Administrator ���� �̸� ����^#^#^#^#^# >> C:\check\w1~82/log.txt

net user > account.txt
net user >> C:\check\w1~82/log.txt

type account.txt | find /I "Administrator" > NUL
if %errorlevel% EQU 0 (
	echo A^|[W-01]  Administrator ������ ������ - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-01] ����- ���α׷�- ������- ��������- ���� ���� ��å - ���� ��å - ���ȿɼ� >> C:\check\w1~82/Action.txt
	echo [W-01] ����: Administrator ���� �̸� �ٲٱ⸦ �����ϱ� ����� ���� �̸����� ���� >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-01] Administrator ������ �������� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del account.txt


rem #################################################################
echo [W-02] Guest ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-02] Guest ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net user guest >> C:\check\w1~82/log.txt
net user guest | find "Ȱ�� ����" | find "�ƴϿ�" > NUL
if %errorlevel% EQU  0 (
	echo A^|[W-02] Guest ������ ��Ȱ��ȭ�Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-02] Guest ������ Ȱ��ȭ�Ǿ� ���� -  [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-02] ����- ����- LUSRMGR.MSC �����- GUEST- �Ӽ� ���� ��� ���Կ� üũ >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-03] ���ʿ��� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^# [W-03] ���ʿ��� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net user >> C:\check\w1~82/log.txt

echo A^|[W-03] ���ʿ��� ������ �����ϴ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-03] C:\check\w1~82/log.txt ������ Ȯ���� "net user ������ /delete" �� �Է��Ͽ� ���ʿ��� ������ �����Ͻÿ� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-04] ���� ��� �Ӱ谪 ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-04] ���� ��� �Ӱ谪 ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find "�Ӱ谪" >> C:\check\w1~82/log.txt
net accounts | find "�Ӱ谪" > thres.txt

for /f "tokens=3" %%a in (thres.txt) do set thres=%%a
if %thres% leq 5 (
	echo A^|[W-04] �Ӱ谪�� 5 ���ϰ����� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-04] �Ӱ谪�� 6 �̻����� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-04] ���� - ���� - secpol.msc - ���� ��å - ���� ��� ��å >> C:\check\w1~82/Action.txt
	echo [W-04] ���� ��� �Ӱ谪�� 5���Ϸ� ����  >> C:\check\w1~82/Action.txt
)

del thres.txt



rem #################################################################
echo [W-05] �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-05] �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt


secedit /export /cfg secpol.txt

type secpol.txt | find /I "ClearTextPassword" | find "0" > NUL
if %errorlevel% EQU 0 (
	echo A^|[W-05] '��� �� ��'���� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-05] '���'���� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>>C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-05] ����-����-SECPOL.MSC-���� ��å-��ȣ ��å - �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ���� ����Ȯ�� >> C:\check\w1~82/Action.txt
	echo [W-05] �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ������ ��� �� ������ ���� >> C:\check\w1~82/Action.txt
)

type secpol.txt | find /I "ClearTextPassword" >> C:\check\w1~82/log.txt

del secpol.txt

rem #################################################################
echo [W-06] ������ �׷쿡 �ּ����� ����� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-06] ������ �׷쿡 �ּ����� ����� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt


net localgroup administrators | find /v "����� �� �����߽��ϴ�." >> C:\check\w1~82/log.txt

echo A^|[W-06] Administrators �׷쿡 ���ʿ��� ������ ������ �����ϴ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-06] C:\check\w1~82/log.txt ������ Ȯ���� ������ �׷쿡 ���Ե� ���ʿ��� ������ Ȯ��, ����ڿ� �����Ͽ� >> C:\check\w1~82/Action.txt
echo ����-����-LUSRMGR.MSC-�׷�-Administrators-�Ӽ�-Administrators �׷쿡�� ���ʿ� ���� ���� �� �׷� ���� >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-07] ���� ���� �� ����� �׷� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-07] ���� ���� �� ����� �׷� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net share >> C:\check\w1~82/log.txt
echo B^|[W-07] �Ϲ� ���� ���丮�� ���� ���ѿ� Everyone ������ �ִ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-07] C:\check\w1~82/log.txt ���Ͽ��� ������ ����ǰ� �ִ� ���� ����� Ȯ���� ��� ���ѿ��� Everyone���� �� ������ ���� >> C:\check\w1~82/Action.txt
echo ����-����-FSMGMT.MSC-����-��� ���ѿ��� Everyone���� �� ������ �����ϰ� ������ �ʿ��� ������ ������ ���� �߰� >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-08] �ϵ��ũ �⺻ ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-08] �ϵ��ũ �⺻ ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net share > log.txt
net share | find /v "����� �� �����߽��ϴ�." >> C:\check\w1~82/log.txt

type log.txt | findstr /I "C$ D$ IPC$" > NUL
if %errorlevel% EQU 0 (
	echo B^|[W-08] �ϵ��ũ �⺻ ���� ���ŵ� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-08] �ϵ��ũ �⺻ ���� ���� �� �� - [���] >> C:\check\w1~82/inspect.txt
	goto W8-1
)

:W8-1
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-08] C:\check\w1~82/log.txt ������ Ȯ���ϰ� �ϵ��ũ �⺻ ������ �����Ͻÿ� >> C:\check\w1~82/Action.txt
echo ����-����-FSMGMT.MSC-����-�⺻��������-���콺 ��Ŭ��-���� ���� >> C:\check\w1~82/Action.txt

del log.txt

rem #################################################################
reg query "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "autoshare" >> C:\check\w1~82/log.txt
reg query "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "autoshare" >> reg.txt

type reg.txt | find "0x0"
if %errorlevel% EQU 0 (
	echo B^|[W-08] �ϵ��ũ �⺻ ���� ������Ʈ�� �� 0 - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-08] �ϵ��ũ �⺻ ���� ������Ʈ�� �� 0 �ƴ� - [���] >> C:\check\w1~82/inspect.txt
	goto W8-2
)

:W8-2
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-08] �ϵ��ũ �⺻ ���� ������Ʈ�� �� 0���� �����Ͻʽÿ� >> C:\check\w1~82/Action.txt
echo ����-����-REGEDIT >> C:\check\w1~82/Action.txt
echo �Ʒ� ������Ʈ�� ���� 0���� ���� (Ű���� ���� ��� ���� ����) >> C:\check\w1~82/Action.txt
echo ��HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer�� >> C:\check\w1~82/Action.txt

del reg.txt

rem #################################################################
echo [W-09] ���ʿ��� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-09] ���ʿ��� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt

echo B^|[W-09] �Ϲ������� ���ʿ��� ����(�Ʒ� ��� ����)�� ���� ���� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-09]C:\check\w1~82/log.txt ������ Ȯ���ϰ� ���ʿ��� ���� �����ϼ���(���̵� �� ǥ ����) >> C:\check\w1~82/Action.txt
echo ����-����-SERVICES.MSC-���ش� ���񽺡�����-�Ӽ�, ���� ����-������, ���� ����-������������ ���ʿ��� ���� ���� >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-10] IIS���� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-10] IIS���� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start >> [W-10]log.txt

type [W-10]log.txt | find /i "IIS ADMIN Service" >nul 2>&1
if %errorlevel% EQU 0 (
	echo B^|[W-10] IIS���񽺰� �ʿ����� ������ ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-10] ����ڿ� ���� �� IIS ���񽺰� ���ʿ��� �� >> C:\check\w1~82/Action.txt
	echo ����-����-SERVICE.MSC-IISADMIN-�Ӽ�-���� ������ ��� ���� ���� �� ������ IIS ���� ���� >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-10] IIS���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del [W-10]log.txt

rem #################################################################
echo [W-11] ���丮 ������ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-11] ���丮 ������ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\inetpub\wwwroot\web.config | find /i "directoryBrowse" >> C:\check\w1~82/log.txt
type C:\inetpub\wwwroot\web.config | find /i "directoryBrowse" > inform.txt

type inform.txt | find /i "false"
if %errorlevel% equ 0 (
	echo B^|[W-11] ���丮 �˻��� ��� �� ������ �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-11] ���丮 �˻��� ������� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-11] ������-��������-���ͳ��������� IIS����-�ش� �� ����Ʈ-IIS-���丮 �˻� ����-��� ���� ���� >> C:\check\w1~82/Action.txt
)

del inform.txt

rem #################################################################
echo [W-12-1] IIS CGI ���� ����(scripts ���翩��)
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-12-1] IIS CGI ���� ����(scripts ���翩��) ^#^#^#^#^# >> C:\check\w1~82/log.txt

dir C:\inetpub /b >> C:\check\w1~82/log.txt
dir C:\inetpub /b > [W-12-1]log.txt

type [W-12-1]log.txt | find /I "scripts" > nul
if %errorlevel% EQU 0 (
	echo B^|[W-12-1] �ش� ���丮�� scripts ������ �����Ұ�� ������ - [���] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-12-1] scripts ������ �������� �ʴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del [W-12-1]log.txt

rem #################################################################
:W12-1
echo [W-12-2] IIS CGI ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-12-2] IIS CGI ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\inetpub\scripts | findstr /i "EVERYONE" >> C:\check\w1~82/log.txt
icacls C:\inetpub\scripts | findstr /i "EVERYONE" > [W-12-2]log.txt

type [W-12-2]log.txt | findstr /i "W M F"
if %errorlevel% EQU 0 (
	echo B^|[W-12-2] �ش� ���丮 Everyone�� ��� ����, ���� ����, ���� ������ �ο��Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-12-2] Ž����-�ش� ���丮-�Ӽ�-����-Everyone�� ��� ����, ���� ����, ���� ���� ���� >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-12-2] �ش� ���丮 Everyone�� ��� ����, ���� ����, ���� ������ �ο����� ���� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del [W-12-2]log.txt


rem #################################################################
echo [W-13] IIS ���� ���丮 ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-13] IIS ���� ���丮 ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config > [W-13]log.txt

type [W-13]log.txt | find /I "enableParentPaths" | find /i "false" > log.txt
if errorlevel 0 goto W13B
if not errorlevel 0 goto W13G

:W13B
	echo B^|[W-13] ���� ���丮 ���� ����� �������� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-13] ������-��������-���ͳ� ��������(IIS) ������-�ش� ������Ʈ-IIS-ASP ����-�θ��� ��� �׸�-False ���� >> C:\check\w1~82/Action.txt
	goto W13

:W13G
	echo B^|[W-13] ���� ���丮 ���� ����� ������ ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
	goto W13

:W13
del[W-13]log.txt
del log.txt


rem #################################################################
echo [W-14] IIS ���ʿ��� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-14] IIS ���ʿ��� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt


echo B^|[W-14] �ش� �� ����Ʈ�� IIS Samples, IIS Help ������丮�� �����ϴ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-14] IIS 7.0(Windows 2008) �̻� ���� �ش���� ���� >> C:\check\w1~82/Action.txt
echo [W-14] Windows 2000, 2003�� ��� Sample ���丮 Ȯ�� �� ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-15] �� ���μ��� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-15] �� ���μ��� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-15] �� ���μ����� ������ ������ �ο��� �������� �����ǰ� �ִ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-15] ���� - ������ - �������� - ��ǻ�� ���� - ���� ����� �� �׷� - ����� ���� - nobody ���� �߰� >> C:\check\w1~82/Action.txt
echo [W-15] ���� - ������ - �������� - ���� ���� ��å - ����� ���� �Ҵ� ����, " ���� �α׿�" �� "nobody" ���� �߰� >> C:\check\w1~82/Action.txt
echo [W-15] ���� - ���� - SERVICES.MSC - IIS Admin Service - �Ӽ� - [�α׿�] ���� ���� ������ nobody ���� �� �н����� >> C:\check\w1~82/Action.txt
echo [W-15] ���� - ���α׷� - ������ Ž���� - IIS�� ��ġ�� ���� �Ӽ� - [����] �ǿ��� nobody ������ �߰��ϰ� ��� ���� üũ >> C:\check\w1~82/Action.txt
echo.>> C:\check\w1~82/Action.txt
echo.[W-15] �߰����� >> C:\check\w1~82/Action.txt
echo [W-15] "������Ʈ �������" - Ȩ ���丮 - �������α׷� ��ȣ(iis ���μ��� ���� ���� ) >> C:\check\w1~82/Action.txt
echo [W-15] ���� ,���� ,���� �� �������� �Ǿ��ִ� ��� >> C:\check\w1~82/Action.txt
echo [W-15] IIS ���μ����� �ý��� ������ ������ �ǹǷ� ��Ŀ�� IIS ���μ����� ������ ȹ���ϸ� �����ڿ� ���ϴ� ������ ���� �� �����Ƿ� ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-16] IIS ��ũ ������
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-16] IIS ��ũ ������ ^#^#^#^#^# >> C:\check\w1~82/log.txt

set file=C:\inetpub\wwwroot

for /f "tokens=*" %%a in ('dir %file% /S /B') do echo %%a >> C:\check\w1~82/log.txt
WHERE /r C:\inetpub\wwwroot *.htm *.url *.html
if %errorlevel% EQU 0 (
	echo B^|[W-16] �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ����� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-16] ��ϵ� �� ����Ʈ�� Ȩ ���丮�� �ִ� �ɺ��� ��ũ, aliases, �ٷΰ��� ������ �����Ͻʽÿ�. >> C:\check\w1~82/Action.txt
	echo ������-�ý��� �� ����-��������-IIS������-�ش� ������Ʈ-�⺻ ����-"���� ���"���� Ȩ ���丮 ��ġ Ȯ�� >> C:\check\w1~82/Action.txt
	echo ���� ��ο� �Էµ� Ȩ ���丮�� �̵��Ͽ� �ٷΰ��� ������ ���� >> C:\check\w1~82/Action.txt
)	else (
	echo B^|[W-16] �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ������� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-17] IIS ���� ���ε� �� �ٿ�ε� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-17] IIS ���� ���ε� �� �ٿ�ε� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\inetpub\wwwroot\web.config | findstr /I "maxAllowedContentLength" >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config | findstr /I "bufferingLimit maxRequestEntityAllowed" >> C:\check\w1~82/log.txt
echo B^|[W-17] �� ���μ����� ���� �ڿ��� �������� �ʴ� ��� (���ε� �� �ٿ�ε� �뷮 �� ����) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo IIS 7���� �̻󿡼��� �⺻������ �������뷮 31457280byte(30MB), �ٿ�ε� 4194304byte(4MB), ���ε� 200000byte(0.2MB)�� �����ϰ� �ֽ��ϴ�. >> C:\check\w1~82/Action.txt
echo ��ϵ� �� ����Ʈ�� ��Ʈ ���丮�� �ִ� web.config ���� �� security �Ʒ��� ���� �׸��� �߰��ϼ���. >> C:\check\w1~82/Action.txt
echo ^<requestFiltering^> >> C:\check\w1~82/Action.txt
echo     ^<requestLimits maxAllowedContentLength="�������뷮" /^> >> C:\check\w1~82/Action.txt
echo ^<requestFiltering^> >> C:\check\w1~82/Action.txt
echo - >> C:\check\w1~82/Action.txt
echo %systemroot% \system32\inetsrv\config\applicationHost.config ���� �� ^<asp/^>�� ^<asp^>���̿� ���� �׸� �߰� >> C:\check\w1~82/Action.txt
echo ^<limits bufferingLimit="���ϴٿ�ε�뷮" maxRequestEntityAllowed="���Ͼ��ε�뷮" /^> >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-18] IIS DB ���� ����� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-18] IIS DB ���� ����� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

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
	echo B^|[W-18] ���� "ó�������"�� ��� �׸� asa, asax�� ��ϵǾ� ���� �ʽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] ���� "ó�������"�� ����׸� asa, asax�� ��ϵǾ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS������-�ش缭��- IIS-"ó���� ����"����-��� �׸� *.asa �� *.asax�� �����ϼ���. >> C:\check\w1~82/Action.txt
)

type filterServer.txt | find /I "true" | findstr /I "asa asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] ���� "��û ���͸�"�� asa, asax Ȯ���ڰ� false�� �����Ǿ� �ֽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] ���� "��û ���͸�"�� asa, asax Ȯ���ڰ� true�� �����Ǿ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS������-�ش缭��-IIS-"��û ���͸�"����-asa �� asax Ȯ���ڸ� false�� �����ϼ���. >> C:\check\w1~82/Action.txt
)

type pathSite.txt | findstr /I "*.asa *.asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] ����Ʈ "ó�������"�� ��� �׸� asa, asax�� ��ϵǾ� ���� �ʽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] ����Ʈ "ó�������"�� ����׸� asa, asax�� ��ϵǾ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS������-�ش� �� ����Ʈ- IIS-"ó���� ����"����-��� �׸� *.asa �� *.asax�� �����ϼ���. >> C:\check\w1~82/Action.txt
)

type filterSite.txt | find /I "true" | findstr /I "asa asax"
if not %errorlevel% EQU 0 (
	echo B^|[W-18] ����Ʈ "��û ���͸�"�� asa, asax Ȯ���ڰ� false�� �����Ǿ� �ֽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-18] ����Ʈ "��û ���͸�"�� asa, asax Ȯ���ڰ� true�� �����Ǿ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-18] IIS������-�ش� �� ����Ʈ-IIS-"��û ���͸�"����-asa �� asax Ȯ���ڸ� false�� �����ϼ���. >> C:\check\w1~82/Action.txt
)

del pathSite.txt
del filterSite.txt
del pathServer.txt
del filterServer.txt


rem #################################################################
echo [W-19] IIS ���� ���丮 ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-19] IIS ���� ���丮 ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-19] �ش� �� ����Ʈ�� IIS Admin, IIS Adminpwd ���� ���丮�� �����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-19] Windows 2003(6.0) �̻� ���� �ش� ���� ���� >> C:\check\w1~82/Action.txt
echo Windows 2000(5.0) >> C:\check\w1~82/Action.txt
echo ����-����-INETMGR �Է�-�� ����Ʈ- IISAdmin, IISAdminpwd ����-���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-20] IIS ������ ���� ACL ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-20] IIS ������ ���� ACL ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls "C:\inetpub\wwwroot" >> C:\check\w1~82/log.txt

icacls "C:\inetpub\wwwroot" | findstr /I "Everyone" > NUL
if %errorlevel% EQU 0 (
  echo B^|[W-20] Ȩ ���丮 ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ ���� - [���] >> C:\check\w1~82/inspect.txt
  echo.>> C:\check\w1~82/Action.txt
  echo [��ġ����] >> C:\check\w1~82/Action.txt
  echo [W-20] ����-����-INETMGR �Է�-����Ʈ Ŭ��-�ش� ������Ʈ-�⺻ ����- Ȩ ���丮 ���� ��� Ȯ�� >> C:\check\w1~82/Action.txt
  echo Ž���⸦ �̿��Ͽ� Ȩ ���丮�� ��� ����-[����]�ǿ��� Everyone ���� Ȯ�� >> C:\check\w1~82/Action.txt
  echo ���ʿ��� Everyone ������ �����Ͻʽÿ�. >> C:\check\w1~82/Action.txt
)	else (
	echo B^|[W-20] Ȩ ���丮 ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ �������� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-21] IIS Exec ��ɾ� �� ȣ�� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-21] IIS Exec ��ɾ� �� ȣ�� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

dir C:\Windows\System32\inetsrv /b >> C:\check\w1~82/log.txt
dir C:\Windows\System32\inetsrv /b > list.txt

echo.[W-21-1] detectlog >> C:\check\w1~82/Action.txt
type list.txt | findstr /i /l ".htr .IDC .stm .shtm .shtml .printer .htw .ida .idq htr.dll idc.dll stm.dll shtm.dll shtml.dll printer.dll htw.dll ida.dll idq.dll" >> C:\check\w1~82/Action.txt

echo.[W-21-1] listlog >> C:\check\w1~82/Action.txt
type list.txt | findstr /i /l ".htr .IDC .stm .shtm .shtml .printer .htw .ida .idq htr.dll idc.dll stm.dll shtm.dll shtml.dll printer.dll htw.dll ida.dll idq.dll" >> C:\check\w1~82/Action.txt
if errorlevel 1 goto W21G
if not errorlevel 1 goto W21B


:W21B
	echo B^|[W-21] htr IDC stm shtm shtml printer htw ida idq�� ������ log���� Ȯ�� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-21] ���� - ���� - INETMGR - ������Ʈ - �ش� ������Ʈ - ó���� ���� ���� >> C:\check\w1~82/Action.txt
	echo [W-21] ����� ���� ���� (htr idc stm shtm shtml printer htw ida idq) >> C:\check\w1~82/Action.txt
	goto W21

:W21G
	echo B^|[W-21] htr IDC stm shtm shtml printer htw ida idq�� ������������  - [��ȣ] >> C:\check\w1~82/inspect.txt
	goto W21

:W21
del list.txt


rem #################################################################
echo [W-22-1] IIS Exec ��ɾ� �� ȣ�� ����(������Ʈ���� ���� ����)
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-22-1] IIS Exec ��ɾ� �� ȣ�� ����(������Ʈ���� ���� ����) ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters /s | find /v "����" >> C:\check\w1~82/log.txt
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters /s | find /v "����" > reg.txt
type reg.txt | find /I "SSIEnableCmdDirective" > NUL

if %errorlevel% EQU 1 (
	echo B^|[W-22] ������Ʈ������ �������� �ʰų� IIS 6.0������ ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
	goto W22
) else (
	echo B^|[W-22] �ش� ������Ʈ������ ������ - [���] >> C:\check\w1~82/inspect.txt
	goto W22-1
)


rem #################################################################
:W22-1
echo [W-22] IIS Exec ��ɾ� �� ȣ�� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-22] IIS Exec ��ɾ� �� ȣ�� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type reg.txt | find /I "SSIEnableCmdDirective" > ssl.txt
type reg.txt | find /I "SSIEnableCmdDirective" >> C:\check\w1~82/log.txt

type ssl.txt | find "0x1"
if %errorlevel% EQU 1 (
	echo B^|[W-22-1] ������Ʈ������ 0��  - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-22-1] �ش� ������Ʈ������ 1�� [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo ���� - ���� - REGEDIT - HKLM\SYSTEM\CurrentControlSet\Services\W32VC\Parameters �˻� >> C:\check\w1~82/Action.txt
	echo DWORD - SSIEnableCmdDirective ���� ã�� ���� 0���� �Է� >> C:\check\w1~82/Action.txt
)

:W22
del reg.txt
del ssl.txt


rem #################################################################
echo [W-23] IIS WebDAV ��Ȱ��ȭ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-23] IIS WebDAV ��Ȱ��ȭ ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config > log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config >> C:\check\w1~82/log.txt

type log.txt | findstr /I "webdav.dll" | find "true"
if errorlevel 1 goto W23G
if not errorlevel 1 goto W23B

:W23B
echo B^|[W-23] WebDav�� ������ - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-23] ���ͳ� ���� ����(IIS) ������ - ���� ���� - IIS - ISAPI �� CGI ���� ����, WebDAV ��뿩�� Ȯ�� (������ ��� ���) >> C:\check\w1~82/Action.txt
echo ���ͳ� ���� ����(IIS) ������ - ���� ���� > IIS - "ISAPI �� CGI ����" ���� WebDAV �׸� ���� - �۾����� �����ϰų�, ���� >> C:\check\w1~82/Action.txt
echo  - "Ȯ�� ��� ���� ���" üũ ���� >> C:\check\w1~82/Action.txt
goto W23

:W23G
echo B^|[W-23] WebDav�� ������������  - [��ȣ] >> C:\check\w1~82/inspect.txt
goto W23


:W23
del log.txt


rem #################################################################
echo [W-24] NetBIOS ���ε� ���� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-24] NetBIOS ���ε� ���� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

wmic nicconfig where "TcpipNetbiosOptions<>null and ServiceName<>'VMnetAdapter'" get Description, TcpipNetbiosOptions >> C:\check\w1~82/log.txt
wmic nicconfig where "TcpipNetbiosOptions<>null and ServiceName<>'VMnetAdapter'" get Description, TcpipNetbiosOptions > netb.txt

type netb.txt | findstr /I "0" > NUL
if %errorlevel% EQU 0 (
	 echo B^|[W-24]  TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ� ���� [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-24] TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ����� ���� [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-24] ���� - ���� - ncpa.cpl - ���� ���� ���� - �Ӽ� - TCP/IP - [�Ϲ�] �ǿ��� [���] Ŭ�� - [WINS] �ǿ��� TCP/IP���� "NetBIOS ��� �� ��" >> C:\check\w1~82/Action.txt
	echo [W-24] �Ǵ�, "NetBIOS over TCP/IP ��� �� ��" ���� >> C:\check\w1~82/Action.txt
)

del netb.txt


rem #################################################################
echo [W-25] FTP ���� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-25] FTP ���� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start | find "Microsoft FTP Service" >> C:\check\w1~82/log.txt

net start | find "Microsoft FTP Service"
if %errorlevel% EQU 0 (
	echo B^|[W-25] FTP ���񽺸� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
        echo [W-25] FTP ���񽺰� ���ʿ��� ��� FTP���� ��� ���� >> C:\check\w1~82/Action.txt
	echo ���� - ���� - SERVICES.MSC - FTP Publishing Service - �Ӽ� - [�Ϲ�] �ǿ��� "���� ����" ��� �� �� ���� ������ ��, FTP ���� ���� >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-25] FTP ���񽺸� ������� �ʴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-26] FTP ���丮 ���ٱ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-26] FTP ���丮 ���ٱ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\inetpub\ftproot >> C:\check\w1~82/log.txt

icacls C:\inetpub\ftproot | findstr /i "EVERYONE"
if %errorlevel% EQU 0 (
	echo B^|[W-26] FTP Ȩ ���丮�� Everyone ������ �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-26] ���ͳ� ���� ���� IIS ���� - FTP ����Ʈ - �ش� FTP ����Ʈ - �Ӽ� - [Ȩ ���丮] �ǿ��� FTP Ȩ ���丮 Ȯ�� >> C:\check\w1~82/Action.txt
	echo [W-26] Ž���� - Ȩ ���丮 - �Ӽ� - [����] �ǿ��� Everyone ���� ���� >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-26] ��ȣ FTP Ȩ ���丮�� Everyone ������ ���� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)


rem #################################################################
echo [W-27] Anonymous FTP ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-27] Anonymous FTP ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config | find "anonymousAuthentication enabled" >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config | find "anonymousAuthentication enabled" > log.txt

type log.txt | find "true"
if %errorlevel% EQU 0 (
	echo B^|[W-27] FTP �͸� ��� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-27] ������-��������-���ͳ� ���� ���� IIS ����-�ش� ������Ʈ-���콺 ��Ŭ��-FTP �Խ� �߰� >> C:\check\w1~82/Action.txt
	echo ���� ���� �������� ���� ȭ���� �͸� üũ �ڽ� ���� >> C:\check\w1~82/Action.txt
) else (
	echo B^|[W-27] FTP �͸� ����� ��� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-28] FTP ���� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-28] FTP ���� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config | find /I "add ipAddress" >> C:\check\w1~82/log.txt

echo B^|[W-28] FTP ���� ���� ���� Ȯ��(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-28] C:\check\w1~82/log.txt ������ Ȯ���ϰ� ����ڿ� �����Ͽ� ���ʿ��� �ּ��� ������ ���� �Ͻʽÿ�. >> C:\check\w1~82/Action.txt
echo ������-��������-���ͳ� ���� ����(IIS)����-�ش� ������Ʈ-FTP IPv4�ּ� �� ������ ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-29] DNS Zone Transfer ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-29] DNS Zone Transfer ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start > log.txt

type log.txt | find "DNS Server"
if %errorlevel% EQU 1 (
	echo B^|[W-29] DNS���񽺸� ������� �ʴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-29] DNS���񽺸� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-29] DNS���񽺸� �ߴ��ϼ���. >> C:\check\w1~82/Action.txt
)

reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find /I "SecureSecondaries" >> reg.txt

type reg.txt | findstr /I "0x1 0x2"
if %errorlevel% EQU 1 (
	echo B^|[W-29] ���� ���� ����� ���� �ʴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-29] ���� ���� ����� �ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-29] W1~82\log\[W-29]log.txt ������ Ȯ���Ͽ� 'SecureSecondaries' ������Ʈ������ 0x0�̰ų� >> C:\check\w1~82/Action.txt
	echo [W-29] 0x3�� �ƴ� �׸��� ���� ���� ���� ���� >> C:\check\w1~82/Action.txt
	echo [W-29] ����-����-DNSMGMT.MSC-�� ��ȸ ����-�ش� ����-�Ӽ�-���� ���� >> C:\check\w1~82/Action.txt
	echo [W-29] ������ �����θ��� ������ ������ ���� IP �߰� >> C:\check\w1~82/Action.txt
)

del log.txt
del reg.txt


rem #################################################################
echo [W-30] RDS (Remote Data Services)����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-30] RDS (Remote Data Services)���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s >> C:\check\w1~82/log.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s >> log.txt

type log.txt | findstr "ADCLaunch"
if errorlevel EQU 0(
	echo B^|[W-30] RDS(Remote Data Services) ���ŵ� (2008 �̻� ��ȣ) >> C:\check\w1~82/inspect.txt
	goto W30
) else (
	echo B^|[W-30] RDS(Remote Data Services) ���ŵ� (2008 �̸� ���) >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-30] ����-����-inetmgr-������Ʈ ���� �� ������ ���丮���� msadc���� >> C:\check\w1~82/Action.txt
	echo ������ ������Ʈ�� Ű/���丮 ���� >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch\RDSServer.DataFactory >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch\AdvancedDataFactory >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch\VbBusObj.VbBusObjCls >> C:\check\w1~82/Action.txt
	goto W30
)

:W30
del log.txt


rem #################################################################
echo [W-31] �ֽ� ������ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-31] �ֽ� ������ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-31] �ֽ� �������� ��ġ���� �ʰų�, ���� ���� �� ����� �������� ���� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-31] ����-����-Winver�Է�-������ ���� Ȯ�� �� �ֽ� ������ �ƴ� ��� >> C:\check\w1~82/Action.txt
echo "https://support.microsoft.com/ko-kr/lifecycle/search"���� �ֽ� ������ �ٿ�ε� �� ��ġ �Ǵ� �ڵ�������Ʈ�� Ȱ�����ּ���. >> C:\check\w1~82/Action.txt
echo �����ͳ� ���� Windows�� ������� �̿��Ͽ� �����ϱ� ������ ������ ��ġ�ÿ��� ��Ʈ��ũ�� �и��� ���¿��� ��ġ �� ���� �����մϴ�.�� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-32] �ֽ� HOT FIX ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-32] �ֽ� HOT FIX ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo C^|[W-32] �ֽ� HotFix�� �ִ��� �ֱ������� ����� ������ ���ų�, �ֽ� HotFix�� �ݿ����� ���� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo C^|[W-32] ���� PMS(Patch Management System) Agent�� ��ġ�Ǿ� ���� �ʰų�, ��ġ�Ǿ� ������ �ڵ���ġ������ ������� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo ���� HOT FIX ���� ��� >> C:\check\w1~82/Action.txt
echo "https://technet.microsoft.com/ko-kr/security/"���� ��ġ ����Ʈ�� ��ȸ�Ͽ�, ������ �ʿ��� ��ġ�� �����Ͽ� �������� ��ġ >> C:\check\w1~82/Action.txt
echo. >> C:\check\w1~82/Action.txt
echo �ڵ� HOT FIX ���� >> C:\check\w1~82/Action.txt
echo Windows �ڵ� ������Ʈ ����� �̿��� ��ġ >> C:\check\w1~82/Action.txt
echo ������-windows update >> C:\check\w1~82/Action.txt
echo. >> C:\check\w1~82/Action.txt
echo PMS��ġ >> C:\check\w1~82/Action.txt
echo Agent�� ��ġ�Ͽ� �ڵ����� ������Ʈ �ǵ��� ������ >> C:\check\w1~82/Action.txt
echo �� ������ġ �� Hot Fix ��� ���� �� �ý��� ������� �䱸�ϴ� ��찡 ��κ��̹Ƿ� �����ڴ� ���񽺿� ������ ���� �ð��뿡 ������ ��. >> C:\check\w1~82/Action.txt
echo �� �Ϻ� Hot Fix�� ����ǰ��ִ� OS ���α׷��̳� ���߿� Application ���α׷��� ������ �� �� �����Ƿ� ��ġ ���� �� >> C:\check\w1~82/Action.txt
echo Application ���α׷��� �����ϰ�, �ʿ��ϴٸ� OS ���� �Ǵ� Application �����Ͼ�� Ȯ�� �۾��� ��ģ �� ��ġ�� ������ ��. >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-33] ��� ���α׷� ������Ʈ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-33] ��� ���α׷� ������Ʈ ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo C^|[W-33] log ������ ���� ��� ���α׷��� �ֽ� ���� ������Ʈ�� ��ġ�Ǿ� �ִ��� Ȯ�����ּ���.(������ ��������) - [���] >> C:\check\w1~82/inspect.txt

echo ���̷κ� >> C:\check\w1~82/log.txt
reg query "HKLM\software\hauri" /s >> C:\check\w1~82/log.txt
reg query hklm\software\hauri\virobot /s | findstr /i "state" >> C:\check\w1~82/log.txt

echo �ȷ� V3 >> C:\check\w1~82/log.txt
reg query hklm\software\ahnlab /s | findstr /i "v3" | findstr /v /i "filter" >> C:\check\w1~82/log.txt
reg query hklm\software\ahnlab /s >> W1~82\log\[W-33]log.txt
reg query hklm\software\ahnlab /s | findstr /i "productname company autoupdateuse v3enginedate version UseSmartUpdate sysmonuse" >> C:\check\w1~82/log.txt

echo Ʈ���帶��ũ�� >> C:\check\w1~82/log.txt
reg query "hklm\software\trendmicro" /s >> C:\check\w1~82/log.txt
reg query "hklm\software\trendmicro" /s | findstr /i "patterndate" >> C:\check\w1~82/log.txt

echo ���� ����Ʈ >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft forefront" /s >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft forefront" /s | findstr /i "productupdate updatesearch" | findstr /i /v "fail loca" >> C:\check\w1~82/log.txt

echo Microsoft security Essentials >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft Antimalware" /s  >> C:\check\w1~82/log.txt
reg query "hklm\software\microsoft\microsoft Antimalware" /s | findstr /i "SignaturesLastUpdated" >> C:\check\w1~82/log.txt


rem #################################################################
echo [W-34] �α��� ������ ���� �� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-34] �α��� ������ ���� �� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

wevtutil qe Application /f:text >> C:\check\w1~82/log.txt
wevtutil qe Security /f:text >> C:\check\w1~82/log.txt
wevtutil qe Setup /f:text >> C:\check\w1~82/log.txt
wevtutil qe System /f:text >> C:\check\w1~82/log.txt

echo D^|[W-34] �α� ��Ͽ� ���� ���������� ����, �м�, ����Ʈ �ۼ� �� ���� ���� ��ġ�� �̷�� ���� �ʴ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo ���ӱ�� ���� ���� �α�, �������α׷� �α�, �ý��� �αױ�Ͽ� ���� ���������� ����, �м�, ����Ʈ �ۼ� �� �����Ͻʽÿ�. >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-35] �������� �׼��� �� �� �ִ� ������Ʈ�� ���
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-35] �������� �׼��� �� �� �ִ� ������Ʈ�� ��� ^#^#^#^#^# >> C:\check\w1~82/log.txt

sc query RemoteRegistry >> C:\check\w1~82/log.txt

sc query RemoteRegistry | FIND "STOPPED"
if %errorlevel% EQU 0 (
	echo D^|[W-35] Remote Registry Service�� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo D^|[W-35] Remote Registry Service�� ��� �� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-35] Remote Registry Service�� �����ؾ��մϴ�. >> C:\check\w1~82/Action.txt
	echo ����-����-SERVICES.MSC �Է�-Remote Registry-�Ӽ� >> C:\check\w1~82/Action.txt
	echo ���� ������ ��� �� ��, ���� ���¸� ������ �ٲ��ֽʽÿ�. >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-36] ��� ���α׷� ��ġ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-36] ��� ���α׷� ��ġ ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start > [W-36]log.txt

type [W-36]log.txt | findstr /i "Alyac Ahnlab Hauri Symantec Trendmicro"
if %errorlevel% EQU 0 (
	echo E^|[W-36] ������α׷��� ��ġ�Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-36] ������α׷��� ��ġ�Ǿ� ���� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-36] ���� ����ڸ� ���� ���̷��� ��� ���α׷��� �ݵ�� ��ġ�Ͽ��� �ϵ��� �� >> C:\check\w1~82/Action.txt
)

del [W-36]log.txt


rem #################################################################
echo [W-37] SAM ���� ���� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-37] SAM ���� ���� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\windows\system32\config\SAM >> C:\check\w1~82/log.txt

icacls C:\windows\system32\config\SAM > log.txt
type log.txt | findstr /I "%COMPUTERNAME% Everyone"
if errorlevel 1 goto W37G
if not errorlevel 1 goto W37B

:W37G
echo E^|[W-37] SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
goto W37

:W37B
echo E^|[W-37] SAM ���� ���ٱ��ѿ� Administrator, System �׷� �� �ٸ� �׷쿡 ������ �����Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-37] c:windows\system32\config\SAM �Ӽ� ���� ã�� ���� >> C:\check\w1~82/Action.txt
echo [W-37] Administrator, System �׷� �� �ٸ� ����� �� �׷���� ���� >> C:\check\w1~82/Action.txt
goto W37

:W37
del log.txt


rem #################################################################
echo [W-38] ȭ�� ��ȣ�� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-38-1] ȭ�� ��ȣ�� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo [ȭ�麸ȣ�� Ȱ��ȭ ����]
reg query "HKCU\Control Panel\Desktop" /v ScreenSaveActive > ScreenSaveActive.txt
reg query "HKCU\Control Panel\Desktop" /v ScreenSaveActive >> C:\check\w1~82/log.txt
for /f "tokens=3" %%a in (ScreenSaveActive.txt) do set ScreenSaveActive=%%a
if %ScreenSaveActive% EQU 0 (
	echo E^|[W-38-1] ȭ�� ��ȣ�Ⱑ �������� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-38-1] ������-���÷���-ȭ�麸ȣ�� ���� ã�� ����-ȭ�� ��ȣ�� Ȱ��ȭ >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-38-1] ȭ�� ��ȣ�Ⱑ ������ ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del ScreenSaveActive.txt

echo E^|[W-38-1] ȭ�� ��ȣ�Ⱑ �������� ���� ���(������Ʈ������ ������Ʈ ���� ���� �� �ֱ⿡ ���� ����) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-38-1] ������-���÷���-ȭ�麸ȣ�� ���� ã�� ����-ȭ�� ��ȣ�� Ȱ��ȭ >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-38-2] ȭ�� ��ȣ�� ��ȣȭ ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-38-2] ȭ�� ��ȣ�� ��ȣȭ ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure > ScreenSaverIsSecure.txt
reg query "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure >> C:\check\w1~82/log.txt
for /f "tokens=3" %%a in (ScreenSaverIsSecure.txt) do set ScreenSaverIsSecure=%%a
if %ScreenSaverIsSecure% EQU 0 (
	echo E^|[W-38-2] ȭ�� ��ȣ�� ��ȣȭ�� ������� ���� ���  - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-38-2] ������-���÷���-ȭ�麸ȣ�� ���� ã�� ����-ȭ�� ��ȣ�� ��ȣ��� ���� >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-38-2] ȭ�� ��ȣ�� ��ȣȭ�� ����ϴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del ScreenSaverIsSecure.txt


rem #################################################################
echo [W-38-3] ȭ�� ��ȣ�� ���ð� 10�� �̸� �� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-38-3] ȭ�� ��ȣ�� ���ð� 10�� �̸� �� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut > ScreenSaveTimeOut.txt
reg query "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut >> C:\check\w1~82/log.txt
for /f "tokens=3" %%a in (ScreenSaveTimeOut.txt) do set ScreenSaveTimeOut=%%a
if %ScreenSaveTimeOut% LEQ 600 (
	echo E^|[W-38-3] ȭ�� ��ȣ�� ��� �ð��� 10�� �̸��� ������ �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo E^|[W-38-3] ȭ�� ��ȣ�� ��� �ð��� 10���� �ʰ��� ������ �����Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-38-3] ������-���÷���-ȭ�麸ȣ�� ���� ã�� ���� >> C:\check\w1~82/Action.txt
	echo [W-38-3] ȭ�麸ȣ�� Ȱ��ȭ-�ٽ� ������ �� �α׿� ȭ��ǥ�� üũ-���ð� 10�� ���� >> C:\check\w1~82/Action.txt
)

del ScreenSaveTimeOut.txt


rem #################################################################
echo [W-39] �α׿� ���� �ʰ� �ý��� ���� ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-39] �α׿� ���� �ʰ� �ý��� ���� ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /s | find /I "shutdownwithoutlogon" > log.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /s | find /I "shutdownwithoutlogon" >> C:\check\w1~82/log.txt

type log.txt | find /I "shutdownwithoutlogon    REG_DWORD    0x1" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-39] �α׿� ���� �ʰ� �ý��� ���� ����� ��� �������� �����Ǿ� ���� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-39] ����-����-SECPOL.MSC-������å-���ȿɼ� ã�� ���� >> C:\check\w1~82/Action.txt
	echo [W-39] �ý��� ���� - �α׿� ���� �ʰ� �ý��� ���� ����� ��� �������� ���� >> C:\check\w1~82/Action.txt
  del log.txt
) else (
	echo E^|[W-39] �α׿� ���� �ʰ� �ý��� ���� ����� ��� �������� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
  del log.txt
)


rem #################################################################
echo [W-40] ���� �ý��ۿ��� ������ �ý��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-40] ���� �ý��ۿ��� ������ �ý��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\check\w1~82/log.txt
echo E^|[W-40] ���� �ý��ۿ��� ������ �ý��� ���� ��å�� Administrators �� �ٸ� ���� �� �׷��� �����ϴ� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-40] ����-����-SECPOL.MSC-������å-����� ���� �Ҵ� ã�� ���� >> C:\check\w1~82/Action.txt
echo ���� �ý��ۿ��� ������ �ý��� ���� ��å�� Administrators �� �ٸ� ���� �� �׷��� ������ ��� ����ڿ� �Բ� Ȯ�� �� ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-41] ���� ���縦 �α��� �� ���� ��� ��� �ý��� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-41] ���� ���縦 �α��� �� ���� ��� ��� �ý��� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "CrashOnAuditFail" | find "0" > NUL
if %errorlevel% EQU  0 (
	echo E^|[W-41] "��� �� ��"���� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-41] "���"���� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-41] ����-����-SECPOL.MSC-������å - ���ȿɼ� ������: ���� ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å�� ����� �� �ԡ� ���� ���� >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-42-1] SAM ������ ������ �͸� ���� ��� �� ��
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-42-1] SAM ������ ������ �͸� ���� ��� �� �� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "RestrictAnonymous" | find "4,1" > NUL
if %errorlevel% EQU 0 (
	echo E^|[W-42-1] SAM ������ ������ �͸� ���� ��� �� �� ��å '���'���� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-42-1] SAM ������ ������ �͸� ���� ��� �� �� ��å '��� �� ��'���� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-42-1] ����-����-SECPOL.MSC-������å - ���ȿɼ� '��Ʈ��ũ �׼��� : SAM ������ ������ �͸� ���� ��� �� ��' ���� ���� >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-42-2] SAM ������ �͸� ���� ��� �� ��
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-42-2] SAM ������ �͸� ���� ��� �� �� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "RestrictAnonymousSAM" | find "1" > NUL
if %errorlevel% EQU 0 (
	echo E^|[W-42-2] SAM ������ �͸� ���� ��� �� �� ��å '���'���� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-42-2] SAM ������ �͸� ���� ��� �� �� ��å '��� �� ��'���� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-42-2] ����-����-SECPOL.MSC-������å - ���ȿɼ� '��Ʈ��ũ �׼��� :SAM ������ �͸� ���� ��� �� ��'�� '���' ���� >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-43] IIS Exec ��ɾ� �� ȣ�� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-43] IIS Exec ��ɾ� �� ȣ�� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s >> C:\check\w1~82/log.txt
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s | find /I "autoadminlogon" > reg.txt

type reg.txt | findstr "1" > NUL
if %errorlevel% EQU 0 (
	echo E^|[W-43] �ش� ������Ʈ������ 1�� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo ���� - ���� - REGEDIT - HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon �˻� >> C:\check\w1~82/Action.txt
	echo DWORD - AutoAdminLogon  ���� ã�� ���� 0���� �Է� >> C:\check\w1~82/Action.txt
	echo DefaultPassword ��Ʈ���� �����Ѵٸ� ���� >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-43] ������Ʈ������ ���������ʰų� ���� 0�� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del reg.txt


rem #################################################################
echo [W-44] �̵��� �̵�� ���� �� ������ ���
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-44] �̵��� �̵�� ���� �� ������ ��� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg secpol.txt
echo f | Xcopy "secpol.txt" "C:\check\w1~82/log.txt"

type secpol.txt | find /I "AllocateDASD" | find "0"
if %errorlevel% EQU  0 (
	echo E^|[W-44] - ��ȣ : ���̵��� �̵�� ���� �� ������ ��롱 ��å�� ��Administrator���� �Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-44] �̵��� �̵�� ���� �� ������ ��롱 ��å�� ��Administrator���� �Ǿ� ���� ���� ��� �Ǵ� ������ �ȵǾ��ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-44] ���� - ���� - SECPOL.MSC - ������å - ���ȿɼ�  ����ġ : �̵��� �̵�� ���� �� ������ ��롱 ��å�� ��Administrators�� �� ���� >> C:\check\w1~82/Action.txt
)

del secpol.txt


rem #################################################################
echo [W-45] ��ũ���� ��ȣȭ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-45] ��ũ���� ��ȣȭ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo E^|[W-45] "������ ��ȣ�� ���� ������ ��ȣȭ" ��å�� ���õǾ� ���� ���� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-45] ���ΰ��� ���� ������ �ݵ�� �ʿ��� ���͸��� ���ؼ��� ��ȣȭ ó�� >> C:\check\w1~82/Action.txt
echo [W-45] ���� ���� - �Ӽ� -  [�Ϲ�] �� - ��� - ��� Ư�� - �������� ��ȣ�� ���� ������ ��ȣȭ�� ���� >> C:\check\w1~82/Action.txt
echo [W-45] �� ���� �Ӽ� - [����] �ǿ��� �㰡�� ����� �ܿ��� ���� �� ���� ���� �Ұ��� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-46] Everyone ��� ������ �͸� ����ڿ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-46] Everyone ��� ������ �͸� ����ڿ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg log.txt
secedit /export /cfg C:\check\w1~82/log.txt

type log.txt | find /i "EveryonIncludesAnonymous"
if %errorlevel% EQU 0 (
	echo A^|[W-46] 'Everyone ��� ������ �͸� ����ڿ��� ����' ��å�� '�ÿ� �� ��'���� �Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo A^|[W-46] 'Everyone ��� ������ �͸� ����ڿ��� ����' ��å�� '���'���� �Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-46] ����-����-SELPOL.MSC-������å-���ȿɼ� >> C:\check\w1~82/Action.txt
	echo [W-46] 'Everyone ��� ������ �͸� ����ڿ��� ����' ��å�� '�ÿ� �� ��' ���� ���� >> C:\check\w1~82/Action.txt
)

del log.txt


rem #################################################################
echo [W-47] ���� ��� �Ⱓ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-47] ���� ��� �Ⱓ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /i "��� �Ⱓ (��):" > log.txt
net accounts | find /i "��� �Ⱓ (��):" >> C:\check\w1~82/log.txt

type log.txt | find /i "��� �Ⱓ (��):"
for /f "tokens=4" %%a in (log.txt) do set log=%%a
if %log% LSS 60 (
	echo A^|[W-47]  ���� ��� �Ⱓ �� ��� �Ⱓ ������� ���� �Ⱓ �� �������� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-47] ����-����-SELPOL.MSC-���� ��å-���� ��� ��å >> C:\check\w1~82/Action.txt
	echo [W-47] ���� ��� �Ⱓ ���� �ð� �� ���� ��� ���� ������� ���� �� ���� ���� ��60�С� ���� >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-47] ���� ��� �Ⱓ �� ������ ��� �Ⱓ ������� ���� �Ⱓ �� �����Ǿ� �ִ� ��� 60�� �̻��� ������ �����ϱ⸦ �ǰ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

net accounts | find /i "��� ���� â (��):" > log.txt
net accounts | find /i "��� ���� â (��):" >> C:\check\w1~82/log.txt

type log.txt | find /i "��� ���� â (��):"
for /f "tokens=4" %%a in (log.txt) do set log=%%a
if %log% LSS 60 (
	echo A^|[W-47]  ���� ��� �Ⱓ �� ��� �Ⱓ ������� ���� �Ⱓ �� �������� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-47] ����-����-SELPOL.MSC-���� ��å-���� ��� ��å >> C:\check\w1~82/Action.txt
	echo [W-47] ���� ��� �Ⱓ ���� �ð� �� ���� ��� ���� ������� ���� �� ���� ���� ��60�С� ���� >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-47] ���� ��� �Ⱓ �� ������ ��� �Ⱓ ������� ���� �Ⱓ �� �����Ǿ� �ִ� ��� 60�� �̻��� ������ �����ϱ⸦ �ǰ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-48] �н����� ���⼺ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-48] �н����� ���⼺ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg log.txt
secedit /export /cfg C:\check\w1~82/log.txt

type log.txt | find /i "PasswordComplexity"
if %errorlevel% EQU 0 (
	echo A^|[W-48] '��ȣ ���⼺�� �����ؾ� ��' ��å�� '��� �� ��'���� �Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-48] ����-����-SECPOL.MSC-���� ��å-��ȣ ��å >> C:\check\w1~82/Action.txt
	echo [W-48] '��ȣ�� ���⼺�� �����ؾ���'�� ������� ���� >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-48] '��ȣ ���⼺�� �����ؾ� ��' ��å�� '���'���� �Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-49] �н����� �ּ� ��ȣ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-49] �н����� �ּ� ��ȣ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /i "�ּ� ��ȣ ����:" > log.txt
net accounts | find /i "�ּ� ��ȣ ����:" >> C:\check\w1~82/log.txt

type log.txt | find /i "�ּ� ��ȣ ����:"
for /f "tokens=4" %%a in (log.txt) do set log=%%a
if %log% LSS 8 (
	echo A^|[W-49] �ּ� ��ȣ ���̰� �������� �ʾҰų� 8���� �̸����� �����Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-49] ����-����-SECPOL.MSC-������å-��ȣ��å >> C:\check\w1~82/Action.txt
	echo [W-49] �ּ� ��ȣ ���̸� 8���ڷ� ���� >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-49] �ּ� ��ȣ ���̰� 8���� �̻����� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-50] �н����� �ִ� ��� �Ⱓ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-50] �н����� �ִ� ��� �Ⱓ ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /i "�ִ� ��ȣ ��� �Ⱓ (��):" > log.txt
net accounts | find /i "�ִ� ��ȣ ��� �Ⱓ (��):" >> C:\check\w1~82/log.txt

type log.txt | find /i "�ִ� ��ȣ ��� �Ⱓ (��):"
for /f "tokens=6" %%a in (log.txt) do set log=%%a
if %log% GTR 90 (
	echo A^|[W-50] �ִ� ��ȣ ��� �Ⱓ�� �������� �ʾҰų� 90���� �ʰ��ϴ� ������ ������ ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-50] ����-����-SECPOL.MSC-������å-��ȣ��å >> C:\check\w1~82/Action.txt
	echo [W-50] ���ִ� ��ȣ ��� �Ⱓ���� ���� ���� ��ȣ ���� �Ⱓ�� ��90�ϡ��� ���� >> C:\check\w1~82/Action.txt
) else (
	echo A^|[W-50] �ִ� ��ȣ ��� �Ⱓ�� 90�� ���Ϸ� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt


rem #################################################################
echo [W-51] �н����� �ּ� ��� �Ⱓ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-51] �н����� �ּ� ��� �Ⱓ ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find "�ּ� ��ȣ ��� �Ⱓ" > minpw.txt
net accounts | find "�ּ� ��ȣ ��� �Ⱓ" >> C:\check\w1~82/log.txt

for /f "tokens=6" %%a in (minpw.txt) do set minpw=%%a
if %minpw% gtr 0 (
	echo A^|[W-51] �ּ� ��ȣ ��� �Ⱓ�� 0���� ŭ - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo A^|[W-51] �ּ� ��ȣ ��� �Ⱓ�� 0���� �����Ǿ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-51] ����-����-SECPOL.MSC �Է�-������å-��ȣ��å >> C:\check\w1~82/Action.txt
	echo �ּҾ�ȣ���Ⱓ�� 1�� �̻����� �����Ͻʽÿ�.�ر��� 1�ϡ� >> C:\check\w1~82/Action.txt
)

del minpw.txt


rem #################################################################
echo [W-52] ������ ����� �̸� ǥ�� �� ��
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-52] ������ ����� �̸� ǥ�� �� �� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\value.txt
type C:\value.txt | find "DontDisplayLastUserName" > display.txt
type C:\value.txt | find "DontDisplayLastUserName" >> C:\check\w1~82/log.txt

for /f "delims=, tokens=2" %%a in (display.txt) do set result=%%a
if %result% EQU 1 (
	echo A^|[W-52] "������ ����� �̸� ǥ�� �� ��"�� "���"���� �����Ǿ� �ֽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
	del C:\value.txt
	del display.txt
)	else (
	echo A^|[W-52] "������ ����� �̸� ǥ�� �� ��"�� "��� �� ��"���� �����Ǿ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-52] ����-����-SECPOL.MSC �Է�-������å-���ȿɼ� >> C:\check\w1~82/Action.txt
	echo [W-52] "��ȭ�� �α׿�: ������ ����� �̸� ǥ�� �� ��"�� "���"���� �����Ͻʽÿ�. >> C:\check\w1~82/Action.txt
	del C:\value.txt
	del display.txt
)


rem #################################################################
echo [W-53] ���� �α׿� ���
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-53] ���� �α׿� ��� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\value.txt

type C:\value.txt | find /i "SeInteractiveLogonRight" >> C:\check\w1~82/log.txt
echo A^|[W-53] ���� �α׿� ��� ��å"�� Administrator, IUSR �� �ٸ� ���� �� �׷��� �����ϸ� �ȵ˴ϴ�.(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-53] ����-����-SECPOL.MSC�Է�-������å-����ڱ����Ҵ�-"���� �α׿� ���"��å Ȯ�� �� Administrator, IUSR ���� ������ �����Ͻʽÿ�. >> C:\check\w1~82/Action.txt

del C:\value.txt


rem #################################################################
echo [W-54] �͸� SID/�̸� ��ȯ ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-54] �͸� SID/�̸� ��ȯ ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg C:\inform.txt
type C:\inform.txt | find /I "LSAAnonymousNameLookup" > Anonymous.txt
type C:\inform.txt | find /I "LSAAnonymousNameLookup" >> C:\check\w1~82/log.txt

for /f "tokens=3" %%a in (Anonymous.txt) do set result=%%a
if %result% EQU 0 (
	echo A^|[W-54] '�͸� SID/�̸� ��ȯ ���'��å�� '��� �� ��'���� �Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
	del C:\inform.txt
	del Anonymous.txt
)	else (
	echo A^|[W-54] '�͸� SID/�̸� ��ȯ ���'��å�� '���'���� �Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-54] '��Ʈ��ũ �׼���:�͸� SID/�̸� ��ȯ ���'��å�� '��� �� ��'���� �����ؾ��մϴ�. >> C:\check\w1~82/Action.txt
	echo ����-����-SECPOL.MSC�Է�-������å-���ȿɼ� >> C:\check\w1~82/Action.txt
	echo '��Ʈ��ũ �׼���: �͸� SID/�̸� ��ȯ ���' ��å�� '��� �� ��'���� ���� >> C:\check\w1~82/Action.txt
	del C:\inform.txt
	del Anonymous.txt
)


rem #################################################################
echo [W-55] �ֱ� ��ȣ ���
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-55] �ֱ� ��ȣ ��� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net accounts | find /I "��ȣ ���" >> uniquepw.txt
net accounts | find /I "��ȣ ���" >> C:\check\w1~82/log.txt

for /f "tokens=4" %%a in (uniquepw.txt) do set result=%%a
if %result% GEQ 4 (
	echo A^|[W-55] �ֱ� ��ȣ ����� 4�� �̻����� �����Ǿ� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo A^|[W-55] �ֱ� ��ȣ ����� 4�� �̸����� �����Ǿ� ���� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-55] �ֱ� ��ȣ ����� 4�� �̻����� �����Ͻʽÿ�. >> C:\check\w1~82/Action.txt
	echo ����-����-SECPOL.MSC�Է�-������å-��ȣ��å >> C:\check\w1~82/Action.txt
	echo '�ֱ� ��ȣ ���'�� 4�� �̻����� ���� >> C:\check\w1~82/Action.txt
)

del uniquepw.txt


rem #################################################################
echo [W-56] �ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-56] �ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /EXPORT /CFG LocalSecurityPolicy.txt

type LocalSecurityPolicy.txt | find /i "LimitBlankPasswordUse=" >> C:\check\w1~82/log.txt

type LocalSecurityPolicy.txt | find /i "LimitBlankPasswordUse=" | find "4,1" > NUL
if %errorlevel% EQU 0 (
 echo A^|[W-56] "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"���� ������ - [��ȣ] >> C:\check\w1~82/inspect.txt
)
if not %errorlevel% EQU 0 (
 echo A^|[W-56] "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "��� ����"���� ������ - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-56] ���� - ���� - secpol.msc - ���� ��å - ���� �ɼ� >> C:\check\w1~82/Action.txt
 echo [W-56] "���� : �ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"���� ���� >> C:\check\w1~82/Action.txt
)

del LocalSecurityPolicy.txt


rem #################################################################
echo [W-57] �����͹̳� ���� ������ ����� �׷� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-57] �����͹̳� ���� ������ ����� �׷� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections > reg.txt
type reg.txt | find /I "0x0" > NUL

if %errorlevel% EQU 0 (
 echo A^|[W-57] "�� ��ǻ�Ϳ� ���� ���� ����" ������ "���" ���� ������ - [��ȣ] [�߰����� ���� �ʿ�, ��ġ���� ����] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-57] ������ - ����� ���� - ������ ���� �̿��� ���� ���� >> C:\check\w1~82/Action.txt
 echo [W-57] ������ - �ý��� - ���� ���� - [����] �� - [���� ����ũ��] �޴� >> C:\check\w1~82/Action.txt
 echo [W-57] "����� ����" ���� ���� ����� ���� �� Ȯ�� >> C:\check\w1~82/Action.txt
) else (
 echo A^|[W-57] "�� ��ǻ�Ϳ� ���� ���� ����" ������ "��� �� ��" ���� ������ - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-57] ������ - ����� ���� - ������ ���� �̿��� ���� ���� >> C:\check\w1~82/Action.txt
 echo [W-57] ������ - �ý��� - ���� ���� - [����] �� - [���� ����ũ��] �޴� >> C:\check\w1~82/Action.txt
 echo [W-57] "�� ��ǻ�Ϳ� ���� ���� ���� ���"�� üũ - "����� ����" ���� ���� ����� ���� �� Ȯ�� >> C:\check\w1~82/Action.txt
)

del reg.txt


rem #################################################################
echo [W-58] �͹̳� ���� ��ȣȭ ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-58] �͹̳� ���� ��ȣȭ ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel > reg.txt
type reg.txt | findstr "0x0 0x1"

if %errorlevel% EQU 0 (
 echo B^|[W-58] �͹̳� ���񽺸� ����ϰ�, ��ȣȭ ������ "����"���� ������ - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-58] ���� - ���� - REGEDIT >> C:\check\w1~82/Action.txt
 echo "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" >> C:\check\w1~82/Action.txt
 echo "MinEncryptionLevel" ���� "2(�߰�)"�̻����� ���� >> C:\check\w1~82/Action.txt
)
if not %errorlevel% EQU 0 (
 echo B^|[W-58] �͹̳� ���񽺸� ������� �ʰų�, ��� �� ��ȣȭ ������ "Ŭ���̾�Ʈ�� ȣȯ����(�߰�)�̻�"���� ������ - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del reg.txt


rem #################################################################
echo [W-59] IIS ������ ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-59] IIS ������ ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config >> C:\check\w1~82/log.txt
type W1~82\log\[W-59]log.txt | find /i "httpErrors errorMode" > iisweb.txt

type iisweb.txt | find /i "custom"
if %errorlevel% EQU 0 (
	echo B^|[W-59] �� ���� ���� �������� ������ �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-59] �� ���� ���� �������� ������ �������� �ʾ� ���� �߻� �� �߿� ���� �� ����Ǵ� ���- [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-59] ������- ���� ����- IIS[���ͳ� ���� ����] ������- �ش� �� ����Ʈ- [���� ������] >> C:\check\w1~82/Action.txt
	echo [�۾�] �ǿ��� [��� ���� ����] - ���� ���� �߻� �� ���� ��ȯ �׸��� ����� ���� ���� �������� ���� >> C:\check\w1~82/Action.txt
)

del iisweb.txt


rem #################################################################
echo [W-60] SNMP ���� ��������
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-60] SNMP ���� �������� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start | find /I "SNMP Service" > nul

if %errorlevel% EQU 0 (
	echo B^|[W-60] SNMP ���񽺸� ������� �ʴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-60] SNMP ���񽺸� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-60] ����-����-SERVICES.MSC-SNMP Service �Ӽ�-"���� ����"�� "��� ����"���� ����-SNMP ���� ���� >> C:\check\w1~82/Action.txt
)

del log.txt


rem #################################################################
echo [W-61] SNMP ���� Ŀ�´�Ƽ��Ʈ���� ���⼺ ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-61] SNMP ���� Ŀ�´�Ƽ��Ʈ���� ���⼺ ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" > log.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" >> C:\check\w1~82/log.txt

type log.txt | findstr /I "public private" >nul
if errorlevel 1 goto W61G
if not errorlevel 1 goto W61B

:W61G
echo B^|[W-61] SNMP ���񽺸� ������� �ʰų�, Community String�� public, private�� �ƴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt

:W61B
echo B^|[W-61] SNMP ���񽺸� ����ϸ�, Community String�� public, private�� ���  - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-61] ����-����-SERVICES.MSC-SNMP Service �Ӽ�-����-[���� Ʈ�� ������] �� üũ�ڽ� ���� �Ǵ� [�޾Ƶ��� Ŀ�´�Ƽ �̸�]���� public, private ���� >> C:\check\w1~82/Action.txt

del log.txt


rem #################################################################
echo [W-62] SNMP Access control ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-62] SNMP Access control ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" | find /i "EnableAuthenticationTraps" > inform.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" >> C:\check\w1~82/log.txt

type inform.txt | find /i "0x1"
if %errorlevel% equ 0 (
	echo B^|[W-62-1] "���� Ʈ�� ������"�� üũ�� �Ǿ��ֽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-62-1] "���� Ʈ�� ������"�� üũ�� �Ǿ����� �ʽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-62-1] ^<���� Ʈ�� ������^> >> C:\check\w1~82/Action.txt
	echo ����-����-SERVICES.MSC �Է�-SNMP Service-�Ӽ�-����-"���� Ʈ�� ������"�� üũ���ּ��� >> C:\check\w1~82/Action.txt
)

del inform.txt


rem #################################################################
echo [W-62] SNMP Access control ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-62] SNMP Access control ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" > inform2.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" >> C:\check\w1~82/log.txt

type inform2.txt | find /i "1"
if %errorlevel% equ 0 (
	echo B^|[W-62-2] "Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�"�� �����Ǿ� �ֽ��ϴ�. - [��ȣ] >> C:\check\w1~82/inspect.txt
)	else (
	echo B^|[W-62-2] "��� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�"�� �����Ǿ� �ֽ��ϴ�. - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-62-2] ^<Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱� ������^> >> C:\check\w1~82/Action.txt
	echo ����-����-SERVICES.MSC �Է�-SNMP Service-�Ӽ�-���� >> C:\check\w1~82/Action.txt
	echo "���� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�" üũ �� �ؿ� �߰� ��ư�� ���� ȣ��Ʈ�� �������ּ��� >> C:\check\w1~82/Action.txt
)

del inform2.txt


rem #################################################################
echo [W-63] DNS ���� ��������
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-63] DNS ���� �������� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt

net start | find "DNS Server"
if %errorlevel% EQU 1 (
echo B^|[W-63] DNS ���񽺸� ������� �ʰų�, ���� ������Ʈ�� "����"���� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
echo B^|[W-63] DNS ���񽺸� ����ϸ�, ���� ������Ʈ�� �����Ǿ� �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-63] ����-����-DNSMGMT.MSC-�� ��ȸ ����-�ش� ����-�Ӽ�-�Ϲ�-���� ������Ʈ-���� ���� >> C:\check\w1~82/Action.txt
)

del log.txt


rem #################################################################
echo [W-64] HTTP/FTP/SMTP ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-64] HTTP/FTP/SMTP ��� ����  ^#^#^#^#^# >> C:\check\w1~82/log.txt

type C:\Windows\System32\inetsrv\config\applicationHost.config  >> C:\check\w1~82/log.txt
type C:\Windows\System32\inetsrv\config\applicationHost.config > logsu.txt
type logsu.txt | findstr /i "suppressDefaultBanner" | find "true"
if %errorlevel% EQU 0 (
	echo B^|[W-64-1] FTP, ���� �� ��� ������ ������ �ʴ� ��� - [��ȣ]  >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-64-1] FTP ���� �� ��ʸ� ����ϴ� ��� - [���]  >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-64-1] IIS ���ͳ� ���� ���� ������ - FTP �޽��� - �⺻ ��� ����� ���� >> C:\check\w1~82/Action.txt
)

del logsu.txt


rem #################################################################
echo [W-64] HTTP/FTP/SMTP ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-64] HTTP/FTP/SMTP ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-64S] HTTP ��� Ȯ�� �ʿ�.(������ ��������) - [���]  >> C:\check\w1~82/inspect.txt
echo B^|[W-64S] SMTP ��� Ȯ�� �ʿ�.(������ ��������) - [���]  >> C:\check\w1~82/inspect.txt

echo.>> C:\check\w1~82/Action.txt
echo [HTTP ��ġ����] >> C:\check\w1~82/Action.txt
echo Microsoft �ٿ�ε� ���Ϳ��� URL Rewrite �ٿ�ε� �� ��ġ https://www.iis.net/downloads/microsoft/url-rewrite >> C:\check\w1~82/Action.txt
echo. >> C:\check\w1~82/Action.txt
echo ������ - �������� - IIS[���ͳ� ���� ����] ������ - �ش� �� ����Ʈ - [URL ���ۼ�] >> C:\check\w1~82/Action.txt
echo �۾� �� - [���� �� ���� - ���� ���� ����...] >> C:\check\w1~82/Action.txt
echo �۾� �� - [�߰�...]- ���� ���� �߰�- ���� ���� �̸�: RESPONSE_SERVER >> C:\check\w1~82/Action.txt
echo [URL ���ۼ�] - �۾� �� - [��Ģ �߰�...] - �ƿ��ٿ�� ��Ģ - �� ��Ģ >> C:\check\w1~82/Action.txt
echo �̸�, �˻� ����, ���� �̸�, ���� ���� - ����- �̸�(N): Remove Server - �˻� ����: ���� ����- ���� �̸�: RESPONSE_SERVER- ���� T: .* >> C:\check\w1~82/Action.txt

echo.>> C:\check\w1~82/Action.txt
echo [SMTP ��ġ����] >> C:\check\w1~82/Action.txt
echo ���� - ���� - cmd - adsutil.vbs ������ �ִ� ���͸��� �̵�- ��ɾ�: cd C:\inetpub\AdminScripts- adsutil.vbs�� ����ϱ� ���� ���� �����ڿ��� ���� �߰� �ʿ� >> C:\check\w1~82/Action.txt
echo [�� ����IIS-���� ����- IIS 6 ���� ȣȯ��- IIS 6 ��ũ���� ����] ��ġ �ʿ� >> C:\check\w1~82/Action.txt
echo IIS���� ���� ���� SMTP ���� ��� Ȯ��- ��ɾ�: cscript adsutil.vbs enum /p smtpsvc >> C:\check\w1~82/Action.txt
echo SMTP ���񽺿� connectresponse �Ӽ� ������ ��� ���� ����- ��ɾ�: cscript adsutil.vbs set smtpsvc/1/connectresponse ��Banner Text >> C:\check\w1~82/Action.txt
echo SMTP ���� �����- ��ɾ�: net stop smtpsvc ����- ��ɾ�: net start smtpsvc ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-65] Telnet ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-65] Telnet ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start  >> C:\check\w1~82/log.txt
net start  >> 65log.txt
type 65log.txt | find /I "Telnet"
if %errorlevel% EQU 1 (
	echo B^|[W-65-1] Telnet Service �� ������ - [��ȣ]  >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-65-1] Telnet Service ������ - [���]  >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-65-1] ���ʿ� �� �ش� ���� ���� - ���� - ���� - SERVICES.MSC - Telnet = �Ӽ� [�Ϲ�] �ǿ��� "���� ����"�� "��� �� ��"���� ������ �� Telnet ���� ���� >> C:\check\w1~82/Action.txt
)

del 65log.txt


rem #################################################################
echo  [W-66] ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-66] ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo B^|[W-66] ������� �ʴ� ���ʿ��� ODBC ������ �ҽ� ����(������ ��������) - [���]  >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-66] ���� - ���� - ������ - ���� ���� - ODBC ������ ���� - �ý��� DSN - �ش� ����̺� Ŭ�� >> C:\check\w1~82/Action.txt
echo ������� �ʴ� ������ �ҽ� ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-67] ���� ���� �� ����� �׷� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-67] ���� ���� �� ����� �׷� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | find /I "MaxIdleTime" > 67log.txt
type 67log.txt | find /I "MaxIdleTime" | find /I 1800000
if %errorlevel% EQU 0 (
	echo B^|[W-67] �������� �� Timeout ���� ������ ����Ǿ� 30������ ������ ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo B^|[W-67] �������� �� Timeout ���� ������ �������� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-67] ���� - ���� - GPEDIT.MSC[���� �׷� ��å ������] >> C:\check\w1~82/Action.txt
	echo  ��ǻ�� ���� - ���� ���ø� - Windows ���� ��� - �͹̳� ���� - ���� ����ũ�鼼�� ȣ��Ʈ - ���� �ð� ���� >> C:\check\w1~82/Action.txt
	echo  [Ȱ�� �������� ���� �͹̳� ���� ���ǿ� �ð����� ����] - [���� ���� ����]�� 30������ ���� >> C:\check\w1~82/Action.txt
)

del 67log.txt


rem #################################################################
echo [W-68] ����� �۾��� �ǽɽ����� ����� ��ϵǾ� �ִ��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-68] ����� �۾��� �ǽɽ����� ����� ��ϵǾ� �ִ��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

schtasks >> C:\check\w1~82/log.txt
echo B^|[W-68] ���ʿ��� ��ɾ ���� �� �ֱ����� ���� �۾��� ���� ���θ� ���� ���� �ʿ�(������ ��������) -[���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-68] GUI Ȯ�� ��� - ������ - �������� - �۾� �����ٷ����� Ȯ�� ��ϵ� ���� �۾��� �����Ͽ� �󼼳��� Ȯ�� ���ʿ��� ���� ���� �� ���� >> C:\check\w1~82/Action.txt
echo CLI�� ��� [W-68]log.txt ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /export /cfg LocalSecurityPolicy.txt
type LocalSecurityPolicy.txt | findstr /i "AuditSystemEvents AuditLogonEvents AuditObjectAccess AuditPrivilegeUse AuditPolicyChange AuditAccountManage AuditProcessTracking AuditDSAccess AuditAccountLogon" > log.txt
type LocalSecurityPolicy.txt | findstr /i "AuditSystemEvents AuditLogonEvents AuditObjectAccess AuditPrivilegeUse AuditPolicyChange AuditAccountManage AuditProcessTracking AuditDSAccess AuditAccountLogon" >> C:\check\w1~82/log.txt
type log.txt | findstr /i "AuditSystemEvents" > SystemEvents.txt

for /f "tokens=3" %%a in (SystemEvents.txt) do set SystemEvents=%%a
if %SystemEvents% == 3 (
 echo C^|[W-69-1] �ý��� �̺�Ʈ ���� - [��ȣ]  >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-1] �ý��� �̺�Ʈ ���� - [���]  >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-1] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-1] "�ý��� �̺�Ʈ ����" �׸� "����,����"�� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditLogonEvents" > LogonEvents.txt

for /f "tokens=3" %%a in (LogonEvents.txt) do set LogonEvents=%%a
if %LogonEvents% == 3 (
 echo C^|[W-69-2] �α׿� �̺�Ʈ ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-2] �α׿� �̺�Ʈ ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-2] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-2] "�α׿� �̺�Ʈ ����" �׸� "����,����"�� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditObjectAccess" > ObjectAccess.txt

for /f "tokens=3" %%a in (ObjectAccess.txt) do set ObjectAccess=%%a
if %ObjectAccess% == 0 (
 echo C^|[W-69-3] ��ü �׼��� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-3] ��ü �׼��� ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-3] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-3] "��ü �׼��� ����" �׸� "���� �� ��"���� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditPrivilegeUse" > PrivilegeUse.txt

for /f "tokens=3" %%a in (PrivilegeUse.txt) do set PrivilegeUse=%%a
if %PrivilegeUse% == 0 (
 echo C^|[W-69-4] ���� ��� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-4] ���� ��� ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-4] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-4] "���� ��� ����" �׸� "���� �� ��"���� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditPolicyChange" > PolicyChange.txt

for /f "tokens=3" %%a in (PolicyChange.txt) do set PolicyChange=%%a
if %PolicyChange% == 1 (
 echo C^|[W-69-5] ��å ���� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-5] ��å ���� ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-5] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-5] "��å ���� ����" �׸� "����"���� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditAccountManage" > AccountManage.txt

for /f "tokens=3" %%a in (AccountManage.txt) do set AccountManage=%%a
if %AccountManage% == 1 (
 echo C^|[W-69-6] ���� ���� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-6] ���� ���� ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-6] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-6] "���� ���� ����" �׸� "����"���� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditProcessTracking" > ProcessTracking.txt

for /f "tokens=3" %%a in (ProcessTracking.txt) do set ProcessTracking=%%a
if %ProcessTracking% == 0 (
 echo C^|[W-69-7] ���μ��� ���� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-7] ���μ��� ���� ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-7] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-7] "���μ��� ���� ����" �׸� "���� �� ��"���� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditDSAccess" > DSAccess.txt

for /f "tokens=3" %%a in (DSAccess.txt) do set DSAccess=%%a
if %DSAccess% == 1 (
 echo C^|[W-69-8] ���丮 ���� �׼��� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-8] ���丮 ���� �׼��� ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-8] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-8] "���丮 ���� �׼��� ����" �׸� "����"���� ���� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-69] ��å�� ���� �ý��� �α� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-69] ��å�� ���� �ý��� �α� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | findstr /i "AuditAccountLogon" > AccountLogon.txt

for /f "tokens=3" %%a in (AccountLogon.txt) do set AccountLogon=%%a
if %AccountLogon% == 1 (
 echo C^|[W-69-9] ���� �α׿� �̺�Ʈ ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo C^|[W-69-9] ���� �α׿� �̺�Ʈ ���� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-69-9] ���� - ���� - SECPOL.MSC - ���� ��å - ���� ��å >> C:\check\w1~82/Action.txt
 echo [W-69-9] "���� �α׿� �̺�Ʈ ����" �׸� "����"���� ���� >> C:\check\w1~82/Action.txt
)

del SystemEvents.txt LogonEvents.txt ObjectAccess.txt PrivilegeUse.txt PolicyChange.txt
del AccountManage.txt ProcessTracking.txt DSAccess.txt AccountLogon.txt
del log.txt LocalSecurityPolicy.txt


rem #################################################################
echo [W-70] �̺�Ʈ �α� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-70] �̺�Ʈ �α� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

wevtutil gl security >> C:\check\w1~82/log.txt
wevtutil gl security > test.txt
type test.txt | find /i "maxSize" > size.txt

for /f "tokens=2" %%a in (size.txt) do set size=%%a
if %size% gtr 10480000 (
	echo D^|[W-70] �ִ� �α� ũ�� "10,240KB �̻�"���� �����Ͽ����ϴ� - [��ȣ] [�߰���ġ �ʿ�, ��ġ���� ����] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-70] Default�� �ƴ� �ٸ� �α״� ����Ȯ���ؾ��մϴ�. >> C:\check\w1~82/Action.txt
	echo [W-70] ^<Default�� �ƴ� �ٸ� �α� Ȯ�ι�^> >> C:\check\w1~82/Action.txt
	echo ����-����-EVENTVWR.MSC�Է�-�ش�α�-�Ӽ�-�Ϲ� >> C:\check\w1~82/Action.txt
	echo �ִ� �α� ũ�⸦ 10,240 �̻����� �������ּ��� >> C:\check\w1~82/Action.txt
) else (
	echo D^|[W-70] �ִ� �α� ũ�� "10,240KB �̸�"���� �����Ͽ����ϴ� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-70] �ִ� �α� ũ�� ���� >> C:\check\w1~82/Action.txt
	echo ����-����-EVENTVWR.MSC�Է�-�ش�α�-�Ӽ�-�Ϲ� >> C:\check\w1~82/Action.txt
	echo �ִ� �α� ũ�⸦ 10,240 �̻����� �������ּ��� >> C:\check\w1~82/Action.txt
	echo [W-70] Default�� �ƴ� �ٸ� �α״� ����Ȯ���ؾ��մϴ� >> C:\check\w1~82/Action.txt
	echo [W-70] ^<Default�� �ƴ� �ٸ� �α� Ȯ�ι�^> >> C:\check\w1~82/Action.txt
	echo ����-����-EVENTVWR.MSC�Է�-�ش�α�-�Ӽ�-�Ϲ� >> C:\check\w1~82/Action.txt
	echo �ִ� �α� ũ�⸦ 10,240 �̻����� �������ּ��� >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-70] �̺�Ʈ �α� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-70] �̺�Ʈ �α� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type test.txt | find /i "retention" >> oldlog.txt
type test.txt | find /i "autoBackup" >> oldlog.txt

type oldlog.txt | find /i "true"
if %errorlevel% equ 0 (
	echo D^|[W-70-1]"�ʿ��� ��� �̺�Ʈ �����"�� üũ�� �ȵǾ��ֽ��ϴ� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-70-1] �ִ� �α� ũ�� ���� �� ���� >> C:\check\w1~82/Action.txt
	echo ����-����-EVENTVWR.MSC�Է�-�ش�α�-�Ӽ�-�Ϲ� >> C:\check\w1~82/Action.txt
	echo "�ʿ��� ��� �̺�Ʈ �����"�� üũ���ּ���. >> C:\check\w1~82/Action.txt
	echo [W-70]"�ʿ��� ��� �̺�Ʈ �����"�� üũ���ּ���. >> C:\check\w1~82/Action.txt
) else (
	echo D^|[W-70-1] "�ʿ��� ��� �̺�Ʈ �����"�� üũ�Ǿ� �ֽ��ϴ� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del oldlog.txt
del test.txt
del size.txt


rem #################################################################
echo [W-71] ���ݿ��� �̺�Ʈ �α� ���� ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# W-71] ���ݿ��� �̺�Ʈ �α� ���� ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls C:\Windows\System32\LogFiles > inform.txt
icacls C:\Windows\System32\LogFiles >> C:\check\w1~82/log.txt

type inform.txt | find /i "everyone"
if %errorlevel% equ 0 (
	echo D^|[W-71] �α� ���丮�� ���ٱ��ѿ� Everyone ������ �ֽ��ϴ� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-71] Ž����-�α� ���丮-�Ӽ�-����_ Everyone ���� >> C:\check\w1~82/Action.txt
) else (
	echo D^|[W-71] �α� ���丮�� ���ٱ��ѿ� Everyone ������ �ֽ��ϴ� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del inform.txt

rem #################################################################
echo [W-72] DoS ���� ��� ������Ʈ�� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-72] DoS ���� ��� ������Ʈ�� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters > dos.txt
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters >> C:\check\w1~82/log.txt
type dos.txt | findstr /i "SynAttackProtect EnableDeadGWDetect KeepAliveTime NoNameReleaseOnDemand" >> inform.txt

type inform.txt | find /i "SynAttackProtect" | findstr /i "1 2"
if %errorlevel% equ 0 (
	echo E^|[W-72-1] SynAttackProtect - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-72-1] SynAttackProtect - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-72-1] ����-����-REGEDIT�Է� >> C:\check\w1~82/Action.txt
	echo HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters �˻� >> C:\check\w1~82/Action.txt
	echo ������Ʈ�� �̸� : SynAttackProtect / ������Ʈ�� �� ���� : REG_DWORD / ��ȿ ���� : 0, 1, 2 / ���� ���� �� : 1 �Ǵ� 2�� ���� >> C:\check\w1~82/Action.txt
	echo ���� ������Ʈ���� ������ �߰����ּ��� >> C:\check\w1~82/Action.txt
)

del dos.txt
del inform.txt

rem #################################################################
echo [W-73] ����ڰ� ������ ����̹��� ��ġ�� �� ���� ��
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-73] ����ڰ� ������ ����̹��� ��ġ�� �� ���� �� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\ControlSet001\Control\Print\Providers\LanMan Print Services\Servers" > log.txt
reg query "HKLM\SYSTEM\ControlSet001\Control\Print\Providers\LanMan Print Services\Servers" >> C:\check\w1~82/log.txt
type log.txt | find /I "AddPrinterDrivers" > log1.txt

type log1.txt | find /I "0x0" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-73] ����ڰ� ������ ����̹��� ��ġ�� �� ���� �� ��å�� ��� ������ ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-73] ����-����-SECPOL.MSC-������å-���ȿɼ�-[��ġ] ����ڰ� ������ ����̹��� ��ġ�� �� ������ - ��å�� ������� ���� >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-73] ����ڰ� ������ ����̹��� ��ġ�� �� ���� �� ��å�� ������� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt
del log1.txt

rem #################################################################
echo [W-74] ���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð�
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-74] ���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" > log.txt
reg query "HKLM\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" >> C:\check\w1~82/log.txt

type log.txt | find /I "enableforcedlogoff    REG_DWORD    0x0" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-74-1] �α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���� ��å�� ��� �������� �����Ǿ� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-74-1] ����-����-SECPOL.MSC-������å-���ȿɼ�-�α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ����- ��å�� ��� �������� ���� >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-74-1] �α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���� ��å�� ������� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

rem #################################################################
echo [W-74] ���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð�
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-74] ���� ������ �ߴ��ϱ� ���� �ʿ��� ���޽ð� ^#^#^#^#^# >> C:\check\w1~82/log.txt

type log.txt | find /I "autodisconnect    REG_DWORD    0xffffffff" >nul
if %errorlevel% EQU 0 (
	echo E^|[W-74-2] ���� ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð� ��å�� 15������ �����Ǿ� ���� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-74-2] ����-����-SECPOL.MSC-������å-���ȿɼ�-���� ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð�-��å�� 15������ ���� >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-74-2] ���� ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð� ��å�� 15������ �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt

rem #################################################################
echo [W-75] ��� �޽��� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-75] ��� �޽��� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" >> C:\check\w1~82/log.txt

echo E^|[W-75] �α��� ��� �޽��� ���� �� ������ �����Ǿ� ���� ���� ���, log ������ ���� �����ڿ� �Բ� ����Ȯ�� ���(������ ��������) - [���] >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-75] ����-����-SECPOL.MSC-������å-���ȿɼ�-�α׿� �õ��ϴ� ����ڿ� ���� �޽��� ����(legalnoticecaption) - ��� �����Է� >> C:\check\w1~82/Action.txt
echo [W-75] ����-����-SECPOL.MSC-������å-���ȿɼ�-�α׿� �õ��ϴ� ����ڿ� ���� �޽��� �ؽ�Ʈ(legalnoticetext) - ��� �����Է� >> C:\check\w1~82/Action.txt

rem #################################################################
echo [W-76] ����ں� Ȩ ���丮 ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-76] ����ں� Ȩ ���丮 ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

icacls "c:\users\Administrator" > log.txt
icacls "c:\users\Administrator" >> C:\check\w1~82/log.txt

type log.txt | find /i "everyone" > nul
if %errorlevel% EQU 0 (
 echo E^|[W-76] Ȩ ���丮�� Everyone ������ �ִ� ��� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-76] ȨC:\�����\[����� ����] >> C:\check\w1~82/Action.txt
 echo [W-76] "All Users, Default USer"�� ���� ���� �� �Ϲݰ��� ���� >> C:\check\w1~82/Action.txt
) else (
 echo E^|[W-76] Ȩ ���丮�� Everyone ������ ���� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt

rem #################################################################
echo [W-77] LAN Manager ���� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-77] LAN Manager ���� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

secedit /EXPORT /CFG LocalSecurityPolicy.txt
type LocalSecurityPolicy.txt | find /i "LmCompatibilityLevel" >> C:\check\w1~82/log.txt
type LocalSecurityPolicy.txt | find /i "LmCompatibilityLevel=4,3" > nul

if %errorlevel% EQU 0 (
 echo E^|[W-77] "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����" �� �����Ǿ� �ִ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
 echo E^|[W-77] "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����" �� �����Ǿ� ���� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
 echo.>> C:\check\w1~82/Action.txt
 echo [��ġ����] >> C:\check\w1~82/Action.txt
 echo [W-77] ���� - ���� - SECPOL.MSC - ���� ��å - ���� �ɼ� >> C:\check\w1~82/Action.txt
 echo [W-77] "��Ʈ��ũ ���� : LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����" ���� >> C:\check\w1~82/Action.txt
)

del LocalSecurityPolicy.txt

rem #################################################################
echo [W-78] ���� ä�� ������ ������ ��ȣȭ �Ǵ� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-78] ���� ä�� ������ ������ ��ȣȭ �Ǵ� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" >> C:\check\w1~82/log.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "requiresignorseal" >> logre.txt

type logre.txt | findstr /I "0x1"
if %errorlevel% EQU 0 (
	echo E^|[W-78-1] ������ ������: ���� ä�� �����͸� ������ ��ȣȭ �Ǵ� ���� '���' - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-78-1] ������ ������: ���� ä�� �����͸� ������ ��ȣȭ �Ǵ� ���� '��� �� ��' - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-78-1] ����-����-SECPOL.MSC-���� ��å-���� �ɼ� >> C:\check\w1~82/Action.txt
	echo [W-78-1] ������ ������: ���� ä�� �����͸� ������ ��ȣȭ �Ǵ� ���� ��å '���'���� ���� >> C:\check\w1~82/Action.txt
)

del logre.txt

rem #################################################################
echo [W-78] ���� ä�� ������ ������ ��ȣȭ �Ǵ� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-78] ���� ä�� ������ ������ ��ȣȭ �Ǵ� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "sealsecurechannel" >> logse.txt

type logsi.txt | findstr /I "0x1"
if %errorlevel% EQU 0 (
	echo E^|[W-78-2] ������ ������: ���� ä�� ������ ������ ���� '���' - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-78-2] ������ ������: ���� ä�� ������ ������ ���� '��� �� ��' - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-78-2] ����-����-SECPOL.MSC-���� ��å-���� �ɼ� >> C:\check\w1~82/Action.txt
	echo [W-78-2] ������ ������: ���� ä�� ������ ������ ���� ��å '���'���� ���� >> C:\check\w1~82/Action.txt
)

del logse.txt

rem #################################################################
echo [W-78] ���� ä�� ������ ������ ��ȣȭ �Ǵ� ����
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-78] ���� ä�� ������ ������ ��ȣȭ �Ǵ� ���� ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "signsecurechannel" >> logsi.txt

type logse.txt | findstr /I "0x1"
if %errorlevel% EQU 0 (
	echo E^|[W-78-3] ������ ������: ���� ä�� ������ ������ ��ȣȭ '���' - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-78-3] ������ ������: ���� ä�� ������ ������ ��ȣȭ '��� �� ��' - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-78-3] ����-����-SECPOL.MSC-���� ��å-���� �ɼ� >> C:\check\w1~82/Action.txt
	echo [W-78-3] ������ ������: ���� ä�� �����͸� ������ ��ȣȭ ��å '���'���� ���� >> C:\check\w1~82/Action.txt
)

del logsi.txt

rem #################################################################
echo [W-79] ���� �� ���丮 ��ȣ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-1] ���� �� ���丮 ��ȣ ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs c: >> C:\check\w1~82/log.txt
chkntfs c: >> logc.txt

type logc.txt | find /I "C: ����̺갡 �����ϴ�."
if %errorlevel% EQU 0 (
	echo E^|[W-79-1] C����̺갡 ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
goto W79C
)

:W79C
type logc.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-1] C����̺갡 NTFS ���� �ý����� ����ϴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-1] C����̺갡 FAT ���� �ý����� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-79-1] ��ɾ� ������Ʈ[DOSâ]���� ������ ���� �Է� >> C:\check\w1~82/Action.txt
	echo [W-79-1] ���� - ���� - CMD - convert C: /fs:ntfs >> C:\check\w1~82/Action.txt
)

rem #################################################################
echo [W-79] ���� �� ���丮 ��ȣ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-2] ���� �� ���丮 ��ȣ ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs d: >> C:\check\w1~82/log.txt
chkntfs d: >> logd.txt

type logd.txt | find /I "D: ����̺갡 �����ϴ�."
if %errorlevel% EQU 0 (
	echo E^|[W-79-2] D����̺갡 ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
goto W79D
)

:W79D
type logd.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-2] D����̺갡 NTFS ���� �ý����� ����ϴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-2] D����̺갡 FAT ���� �ý����� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-79-2] ��ɾ� ������Ʈ[DOSâ]���� ������ ���� �Է� >> C:\check\w1~82/Action.txt
	echo [W-79-2] ���� - ���� - CMD - convert D: /fs:ntfs >> C:\check\w1~82/Action.txt
)

rem #################################################################
echo [W-79] ���� �� ���丮 ��ȣ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-3] ���� �� ���丮 ��ȣ ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs e: >> C:\check\w1~82/log.txt
chkntfs e: >> loge.txt

type loge.txt | find /I "E: ����̺갡 �����ϴ�."
if %errorlevel% EQU 0 (
	echo E^|[W-79-3] E����̺갡 ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
goto W79E
)

:W79E
type loge.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-3] E����̺갡 NTFS ���� �ý����� ����ϴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-3] E����̺갡 FAT ���� �ý����� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-79-3] ��ɾ� ������Ʈ[DOSâ]���� ������ ���� �Է� >> C:\check\w1~82/Action.txt
	echo [W-79-3] ���� - ���� - CMD - convert E: /fs:ntfs >> C:\check\w1~82/Action.txt
)


rem #################################################################
echo [W-79] ���� �� ���丮 ��ȣ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-79-4] ���� �� ���丮 ��ȣ ^#^#^#^#^# >> C:\check\w1~82/log.txt

chkntfs f: >> C:\check\w1~82/log.txt
chkntfs f: >> logf.txt

type logf.txt | find /I "F: ����̺갡 �����ϴ�."
if %errorlevel% EQU 0 (
	echo E^|[W-79-4] F����̺갡 ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
goto W79F
)

:W79GF
type logf.txt | find /I "NTFS"
if %errorlevel% EQU 0 (
	echo E^|[W-79-4] F����̺갡 NTFS ���� �ý����� ����ϴ� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-79-4] F����̺갡 FAT ���� �ý����� ����ϴ� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-79] ��ɾ� ������Ʈ[DOSâ]���� ������ ���� �Է� >> C:\check\w1~82/Action.txt
	echo [W-79] ���� - ���� - CMD - convert F: /fs:ntfs >> C:\check\w1~82/Action.txt
)

del logc.txt
del logd.txt
del loge.txt
del logf.txt


rem #################################################################
echo [W-80] ��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-80] ��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ ^#^#^#^#^# >> C:\check\w1~82/log.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "DisablePasswordChange" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | find /I "DisablePasswordChange" > logd.txt

type logd.txt | find /I "0x0"
if %errorlevel% EQU 0 (
	echo E^|[W-80-1] '��ǻ�� ���� ��ȣ ���� ��� �� ��' ��å�� ������� ���� - [��ȣ] >> C:\check\w1~82/inspect.txt
) else (
	echo E^|[W-80-1] '��ǻ�� ���� ��ȣ ���� ��� �� ��' ��å�� ����� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-80-1] ����-����-SECPOL.MSC-���� ��å-���� �ɼ� >> C:\check\w1~82/Action.txt
	echo [W-80-1] ������ ������: ��ǻ�� ���� ��ȣ ���� ���� ��� �� �� �� ��� �� �� >> C:\check\w1~82/Action.txt
)

del logd.txt


rem #################################################################
echo [W-81] �������α׷� ��� �м�
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-81] �������α׷� ��� �м� ^#^#^#^#^# >> C:\check\w1~82/log.txt

echo "�������α׷� ���" >> C:\check\w1~82/log.txt
dir "C:\Users\Administarator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >> C:\check\w1~82/log.txt
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" >> C:\check\w1~82/log.txt
echo. >> C:\check\w1~82/log.txt

echo "������Ʈ�� Run ���" >> C:\check\w1~82/log.txt
echo "Windows x86 �������α׷� ���" >> C:\check\w1~82/log.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> C:\check\w1~82/log.txt
echo. >> C:\check\w1~82/log.txt

echo "Windows x64 �������α׷� ���" >> C:\check\w1~82/log.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" >> C:\check\w1~82/log.txt

echo E^|[W-81] �������α׷� ����� ���������� �˻��ϰ� ���ʿ��� ���� üũ ������ �� ��� (2012 ���� �ش� ����) >> C:\check\w1~82/inspect.txt
echo E^|[W-81] �������α׷� ����� ���������� �˻����� �ʰ�, ���� �� ���ʿ��� ���񽺵� ����ǰ� �ִ� ���(������ ��������) >> C:\check\w1~82/inspect.txt
echo.>> C:\check\w1~82/Action.txt
echo [��ġ����] >> C:\check\w1~82/Action.txt
echo [W-81] ���� - �˻� - msconfig ��ɾ� �Է� >> C:\check\w1~82/Action.txt
echo [W-81] ���� ���α׷� �� Ŭ�� - ���� ���α׷� ��� �� ���ʿ��ϰų� �ǽɽ����� �׸� üũ ǥ�� ���� >> C:\check\w1~82/Action.txt


rem #################################################################
echo [W-82] Windows ���� ��� ���
echo.>> C:\check\w1~82/log.txt
echo ^#^#^#^#^#^#^# [W-82] Windows ���� ��� ��� ^#^#^#^#^# >> C:\check\w1~82/log.txt

net start >> C:\check\w1~82/log.txt
net start | find /I "SQL Server" >> log.txt

type log.txt | find /I "SQL Server"
if %errorlevel% EQU 0 (
	echo E^|[W-82] 'SQL Server'�� ���� ���� ��� - [���] >> C:\check\w1~82/inspect.txt
	echo.>> C:\check\w1~82/Action.txt
	echo [��ġ����] >> C:\check\w1~82/Action.txt
	echo [W-82] SQL Server ���񽺰� ���ʿ��� ��� SQL Server ���� ��� ���� >> C:\check\w1~82/Action.txt
	echo [W-82] ���� - ���� - SERVICES.MSC - SQL Server - �Ӽ� - [�Ϲ�] �ǿ��� "���� ����" ��� �� �� ���� ������ ��, SQL Server ���� ���� >> C:\check\w1~82/Action.txt
) else (
	echo E^|[W-82] 'SQL Server'�� ���� ������ ���� ��� - [��ȣ] >> C:\check\w1~82/inspect.txt
)

del log.txt

pause