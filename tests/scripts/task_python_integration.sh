#!/bin/bash
export PYTHONPATH=python:apps/extension/python
export PYTHONPATH=${PYTHONPATH}:apps/graph_executor/python:apps/graph_executor/nnvm/python
export LD_LIBRARY_PATH=lib:${LD_LIBRARY_PATH}

# Test TVM
make cython || exit -1

# Test extern package package
cd apps/extension
make || exit -1
cd ../..
python -m nose -v apps/extension/tests || exit -1

# Test NNVM integration
cd apps/graph_executor
make || exit -1
cd ../..
python -m nose -v apps/graph_executor/tests || exit -1

TVM_FFI=cython python -m nose -v tests/python/integration || exit -1
TVM_FFI=ctypes python3 -m nose -v tests/python/integration || exit -1
TVM_FFI=cython python -m nose -v tests/python/contrib || exit -1
TVM_FFI=ctypes python3 -m nose -v tests/python/contrib || exit -1