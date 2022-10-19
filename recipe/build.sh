#!/bin/sh

mkdir build
cd build

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DUSE_SYSTEM_PATHS_FOR_PYTHON_INSTALLATION:BOOL=ON \
      -DPython3_EXECUTABLE:PATH=$PYTHON \
      -DPYTHON_EXECUTABLE:PATH=$PYTHON

cmake --build . --config Release
cmake --build . --config Release --target install
# UNIT_Pose_TEST excluded as a temporary workaround for https://github.com/ignitionrobotics/ign-math/issues/161
# UNIT_SpeedLimiter_TEST excluded as a workaround for https://github.com/ignitionrobotics/ign-math/issues/203
# UNIT_Helpers_TEST excluded as a workaround for https://github.com/conda-forge/libignition-math4-feedstock/pull/31
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|UNIT_Pose_TEST|UNIT_SpeedLimiter_TEST|UNIT_Helpers_TEST"
fi
