#!/bin/sh

if [ ${target_platform} == "linux-ppc64le" ]; then
  # Disable tests
  IGN_TEST_CMD=-DBUILD_TESTING:BOOL=OFF
  NUM_PARALLEL=-j1
else
  IGN_TEST_CMD=-DBUILD_TESTING:BOOL=ON
  NUM_PARALLEL=
fi


mkdir build
cd build

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DUSE_SYSTEM_PATHS_FOR_PYTHON_INSTALLATION:BOOL=ON \
      -DPython3_EXECUTABLE:PATH=$PYTHON \
      -DPYTHON_EXECUTABLE:PATH=$PYTHON \
      $IGN_TEST_CMD

cmake --build . --config Release
cmake --build . --config Release --target install
# UNIT_Pose_TEST excluded as a temporary workaround for https://github.com/ignitionrobotics/ign-math/issues/161
# UNIT_SpeedLimiter_TEST excluded as a workaround for https://github.com/ignitionrobotics/ign-math/issues/203
# UNIT_Helpers_TEST excluded as a workaround for https://github.com/conda-forge/libignition-math4-feedstock/pull/31
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|UNIT_Pose_TEST|UNIT_SpeedLimiter_TEST|UNIT_Helpers_TEST"
fi
