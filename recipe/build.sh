#!/bin/sh

mkdir build
cd build

cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True

cmake --build . --config Release
cmake --build . --config Release --target install
# UNIT_Pose_TEST excluded as a temporary workaround for https://github.com/ignitionrobotics/ign-math/issues/161
# UNIT_SpeedLimiter_TEST excluded as a workaround for https://github.com/ignitionrobotics/ign-math/issues/203
ctest --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|UNIT_Pose_TEST|UNIT_SpeedLimiter_TEST"
