Name:          sky-remote
Version:       0.1
Release:       1
Summary:   Allows the phone to be used as a remote control over the wifi connection.
Group:         System/Patches
Vendor:        Anant Gajjar
Distribution:  SailfishOS
Packager: Anant Gajjar
License:       GPL

Requires: sailfish-version >= 3.3.0
Requires: pyotherside-qml-plugin-python3-qt5
Requires: libsailfishapp-launcher
Requires: python3-setuptools
Requires: python3-pip

BuildArch: noarch

%description
This is an application to control you Sky Q Box. Commands are sent over wifi so your phone and Sky Q box need to be connected to the same network.

This is wrapping the python pyskyqremote library developed by Roger Selwyn (https://pypi.org/project/pyskyqremote/#description) 
 

Features:
- Automatically detects the ip address of the Sky Q box. 
- Shows details on current media
- Selected buttons available on cover (user configurable)


%files
/usr/share/applications/*
/usr/share/icons/hicolor/86x86/apps/*
/usr/share/sky-remote/*

%post
pip3 install pyskyqremote
cd /usr/share/sky-remote/translations

currentlang1=$(grep LANG /var/lib/environment/nemo/locale.conf | cut -d= -f2 | cut -d. -f1)

currentlang2=$(grep LANG /var/lib/environment/nemo/locale.conf | cut -d= -f2 | cut -d_ -f1)

file1="sky-remote-${currentlang1}.qm"
file2="sky-remote-${currentlang2}.qm"

echo $file1
echo $file2

if [ ! -f $file1 ]  && [ ! -f $file2 ] 
then ln -s sky-remote.qm $file1
else echo "file exists" 
fi
 

%preun
 
cd /usr/share/sky-remote/translations 

currentlang1=$(grep LANG /var/lib/environment/nemo/locale.conf | cut -d= -f2 | cut -d. -f1)

file1="sky-remote-${currentlang1}.qm"
if [ -L $file1 ]
then rm -f  $file1
fi

%postun
if [ $1 = 0 ]; then
pip3 uninstall -y pyskyqremote
su -l nemo -c  "dconf reset -f /apps/sky-remote/" || true

else
if [ $1 = 1 ]; then
 
echo "It's just upgrade"
fi
fi

%changelog
*Fri Aug 21 2020 Builder <builder@...>
0.1-1
- First build
