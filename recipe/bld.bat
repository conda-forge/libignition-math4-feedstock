mkdir build
cd build

cmake ^
    -G "NMake Makefiles" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DUSE_SYSTEM_PATHS_FOR_PYTHON_INSTALLATION:BOOL=ON ^
    -DPython3_EXECUTABLE:PATH=%PYTHON% ^
    -DPYTHON_EXECUTABLE:PATH=%PYTHON% ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
:: Skip StopWatch_TEST.py and Matrix3_TEST.py as workaround for https://github.com/ignitionrobotics/ign-math/issues/416
:: Skip UNIT_Stopwatch_TEST as on Windows it is quite flaky
ctest --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|StopWatch_TEST.py|Matrix3_TEST.py|UNIT_Stopwatch_TEST"
if errorlevel 1 exit 1
