Name:          MurMurHash
Version:       %{version}
Release:       %{buildnumber}%{?dist}
Summary:       An implemnetation of MurMurHash for C++
Group:         Development/Tools
License:       MIT
BuildRequires: probecmake >= 2.8
Requires:      dpiUser
ExclusiveArch: x86_64

%description

%prep
cd ~/rpmbuild/BUILD
rm -rf %{name}
mkdir %{name}
cd %{name}
tar xzf ~/rpmbuild/SOURCES/%{name}-%{version}.tar.gz
if [ $? -ne 0 ]; then
   exit $?
fi

%build
# SKIP_BUILD_RPATH, CMAKE_SKIP_BUILD_RPATH, 
cd %{name}/
PATH=/usr/local/gcc/bin:/usr/local/probe/bin:$PATH
rm -f  CMakeCache.txt
cd 3rdparty
unzip -u gtest-1.7.0.zip
cd ..
if [ "%{buildtype}" == "-DUSE_LR_DEBUG=OFF" ]; then
   /usr/local/probe/bin/cmake -DVERSION:STRING='%{version}.%{buildnumber}' \
      -DCMAKE_CXX_COMPILER_ARG1:STRING=' -fPIC -Ofast -m64 -isystem/usr/local/gcc/include -isystem/usr/local/probe/include -Wl,-rpath -Wl,/usr/local/probe/lib -Wl,-rpath -Wl,/usr/local/gcc/lib64 ' \
      -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_CXX_COMPILER=/usr/local/gcc/bin/g++
elif [ "%{buildtype}" == "-DUSE_LR_DEBUG=ON" ]; then
   /usr/local/probe/bin/cmake -DVERSION:STRING='%{version}.%{buildnumber}' \
      -DCMAKE_CXX_COMPILER_ARG1:STRING=' -fPIC -Ofast -m64 --coverage -isystem/usr/local/gcc/include -isystem/usr/local/probe/include -Wl,-rpath -Wl,/usr/local/probe/lib -Wl,-rpath -Wl,/usr/local/gcc/lib64 ' \
      -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_CXX_COMPILER=/usr/local/gcc/bin/g++
fi

make
./UnitTestRunner
if [ "%{buildtype}" == "-DUSE_LR_DEBUG=ON" ]; then
   /usr/local/probe/bin/CodeCoverage.py
fi
mkdir -p $RPM_BUILD_ROOT/usr/local/probe/lib
cp -rfd lib%{name}.so* $RPM_BUILD_ROOT/usr/local/probe/lib
mkdir -p $RPM_BUILD_ROOT/usr/local/probe/include
cp src/*.h $RPM_BUILD_ROOT/usr/local/probe/include


%post

%preun

%postun

%files
%defattr(-,dpi,dpi,-)
/usr/local/probe/lib
/usr/local/probe/include
