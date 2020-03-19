echo "Configuring and building Thirdparty/DBoW2 ..."

if [ -z "$1" ]; then 
    DYNASLAM_BUILD_TYPE=Release
else
    DYNASLAM_BUILD_TYPE="$1"
fi

cd Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=${DYNASLAM_BUILD_TYPE}
make -j

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=${DYNASLAM_BUILD_TYPE}
make -j

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building DynaSLAM ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=${DYNASLAM_BUILD_TYPE}
make -j
