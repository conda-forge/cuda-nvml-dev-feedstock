#!/bin/bash

# Install to conda style directories
[[ -d lib64 ]] && mv lib64 lib
mkdir -p ${PREFIX}/lib
[[ -d pkg-config ]] && mkdir -p ${PREFIX}/lib && mv pkg-config ${PREFIX}/lib/pkgconfig
[[ -d "$PREFIX/lib/pkgconfig" ]] && sed -E -i "s|cudaroot=.+|cudaroot=$PREFIX|g" $PREFIX/lib/pkgconfig/nvidia-ml-*.pc

[[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ ${target_platform} == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

for i in `ls`; do
    [[ $i == "build_env_setup.sh" ]] && continue
    [[ $i == "conda_build.sh" ]] && continue
    [[ $i == "metadata_conda_debug.yaml" ]] && continue

    if [[ $i == "lib" ]] || [[ $i == "include" ]]; then
        # Headers and libraries are installed to targetsDir
        mkdir -vp ${PREFIX}/${targetsDir}
        mkdir -vp ${PREFIX}/$i
        cp -rv $i ${PREFIX}/${targetsDir}
        # Nothing to be symlinked in $PREFIX/lib
    # else
        # Skip all other files (only samples here)
        # mkdir -p ${PREFIX}/${targetsDir}/${PKG_NAME}
        # cp -rv $i ${PREFIX}/${targetsDir}/${PKG_NAME}
    fi

    if [[ $i == "lib" ]]; then
        for j in `find $i -name "*.so*"`; do
            echo mkdir -vp `dirname ${PREFIX}/$j`
            mkdir -vp `dirname ${PREFIX}/$j`
            # Shared libraries are symlinked in $PREFIX/lib
            echo ln -svf ${PREFIX}/${targetsDir}/$j ${PREFIX}/$j
            ln -svf ${PREFIX}/${targetsDir}/$j ${PREFIX}/$j

            if [[ $j =~ \.so($|\.) ]]; then
                echo patchelf --force-rpath --set-rpath '$ORIGIN' ${PREFIX}/${targetsDir}/$j
                patchelf --force-rpath --set-rpath '$ORIGIN' ${PREFIX}/${targetsDir}/$j
            fi
        done
    fi
done
