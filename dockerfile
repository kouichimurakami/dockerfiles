#利用するubuntuのイメージ
FROM ubuntu:16.04
#環境構築
RUN apt-get update -qq && apt-get -y install \
        autoconf \
        automake \
        build-essential \
        cmake \
        git-core \
        libass-dev \
        libfreetype6-dev \
        libsdl2-dev \
        libtool \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libxcb1-dev \
        libxcb-shm0-dev \
        libxcb-xfixes0-dev \
        pkg-config \
        texinfo \
        wget \
        zlib1g-dev
#ffmpegのディレクトリ作成
RUN mkdir -p ~/ffmpeg_sources ~/bin && \
#NASMをインストール
    cd ~/ffmpeg_sources && \
    wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2 && \
    tar xjvf nasm-2.13.03.tar.bz2 && \
    cd nasm-2.13.03 && \
    ./autogen.sh && \
    PATH="HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
    make && \
    make install
#Yasmをインストール
RUN cd ~/ffmpeg_sources && \
    wget -O yasm-1.3.0.tar.gz https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
    tar xzvf yasm-1.3.0.tar.gz && \
    cd yasm-1.3.0 && \
    ./configure --prefix="$HOME/ffmpeg_build" -- bindir="$HOME/bin" && \
    make && \
    make install
#libx264をインストール
RUN apt-get install -y libx264-dev
#libx265をインストール
RUN apt-get install -y libx265-dev libnuma-dev
#libvpxをインストール
RUN apt-get install -y libvpx-dev
#CMAKE3.6.2をインストール
#libfdk-aac
RUN apt-get install -y libfdk-aac-dev
#libmp3lameをインストール
RUN apt-get install -y libmp3lame-dev
#libopusをインストール
RUN apt-get install -y libopus-dev
#libaomをインストール
RUN cd ~/ffmpeg_sources && \
    git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
    mkdir aom_build && \
    cd aom_build && \
    PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE=off -DENABLE_NASM=on ../aom && \
    PATH="$HOME/bin:$PATH" make && \
    make install
#ffmpegをインストール
RUN cd ~/ffmpeg_sources && \
    wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --enable-libaom \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \ 
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree && \
    PATH="$HOME/bin:$PATH" make && \
    make install && \
    hash -r \
#python3とnumpyをインストール
RUN apt-get install -y python3-dev python3-numpy
#C++をマルチスレッドで動かす
RUN apt-get install -y libtbb2 libtbb-dev
#JPEG形式、PNG形式、TIFF形式、JPEG2000形式を扱えるようにするCライブラリ
RUN apt-get install -y libjpeg-dev libpng16-dev libtiff5-dev libjasper-dev
#IEE1394規格に準拠したカメラ
RUN apt-get install -y libdc1394-22-dev
#GTK+3.0をインストール
RUN apt-get install -y libfontconfig1-dev libfreetype6-dev libpng-dev libcairo2-dev
RUN apt-get install -y libpng12-dev libgdk-pixbuf2.0-dev
RUN apt-get install -y libxft-dev libpango1.0-dev
RUN apt-get install -y libgtk3.0
#OPEN-CVをインストール
RUN wget https://github.com/opencv/opencv/archive/3.3.0.tar.gz && tar xvf 3.3.0.tar.gz && cd opencv-3.3.0 && cmake /
make -G "Unix Makefiles" --build . -D BUILD_CUDA_STUBS=OFF -D BUILD_DOCS=OFF
#-D BUILD_EXAMPLES=OFF -D BUILD_JASPER=OFF -D BUILD_JPEG=OFF -D BUILD_OPENEXR=OFF \
#-D BUILD_PACKAGE=ON -D BUILD_PERF_TESTS=OFF -D BUILD_PNG=OFF -D BUILD_SHARED_LIBS=ON \
#-D BUILD_TBB=OFF -D BUILD_TESTS=OFF -D BUILD_TIFF=OFF -D BUILD_WITH_DEBUG_INFO=ON \
#-D BUILD_ZLIB=OFF -D BUILD_WEBP=OFF -D BUILD_opencv_apps=ON -D BUILD_opencv_calib3d=ON \
#-D BUILD_opencv_core=ON -D BUILD_opencv_cudaarithm=OFF -D BUILD_opencv_cudabgsegm=OFF \
#-D BUILD_opencv_cudacodec=OFF -D BUILD_opencv_cudafeatures2d=OFF -D BUILD_opencv_cudafilters=OFF \
#-D BUILD_opencv_cudaimgproc=OFF -D BUILD_opencv_cudalegacy=OFF -D BUILD_opencv_cudaobjdetect=OFF \
#-D BUILD_opencv_cudaoptflow=OFF -D BUILD_opencv_cudastereo=OFF -D BUILD_opencv_cudawarping=OFF \
#-D BUILD_opencv_cudev=OFF -D BUILD_opencv_features2d=ON -D BUILD_opencv_flann=ON \
#-D BUILD_opencv_highgui=ON -D BUILD_opencv_imgcodecs=ON -D BUILD_opencv_imgproc=ON \
#-D BUILD_opencv_java=OFF -D BUILD_opencv_ml=ON -D BUILD_opencv_objdetect=ON \
#-D BUILD_opencv_photo=ON -D BUILD_opencv_python2=OFF -D BUILD_opencv_python3=ON \
#-D BUILD_opencv_shape=ON -D BUILD_opencv_stitching=ON -D BUILD_opencv_superres=ON \
#-D BUILD_opencv_ts=ON -D BUILD_opencv_video=ON -D BUILD_opencv_videoio=ON \
#-D BUILD_opencv_videostab=ON -D BUILD_opencv_viz=OFF -D BUILD_opencv_world=OFF \
#-D CMAKE_BUILD_TYPE=RELEASE -D WITH_1394=ON -D WITH_CUBLAS=OFF -D WITH_CUDA=OFF \
#-D WITH_CUFFT=OFF -D WITH_EIGEN=ON -D WITH_FFMPEG=ON -D WITH_GDAL=OFF -D WITH_GPHOTO2=OFF \
#-D WITH_GIGEAPI=ON -D WITH_GSTREAMER=OFF -D WITH_GTK=ON -D WITH_INTELPERC=OFF -D WITH_IPP=ON \
#-D WITH_IPP_A=OFF -D WITH_JASPER=ON -D WITH_JPEG=ON -D WITH_LIBV4L=ON -D WITH_OPENCL=ON \
#-D WITH_OPENCLAMDBLAS=OFF -D WITH_OPENCLAMDFFT=OFF -D WITH_OPENCL_SVM=OFF -D WITH_OPENEXR=ON \
#-D WITH_OPENGL=ON -D WITH_OPENMP=OFF -D WITH_OPENNI=OFF -D WITH_PNG=ON -D WITH_PTHREADS_PF=OFF \
#-D WITH_PVAPI=OFF -D WITH_QT=ON -D WITH_TBB=ON -D WITH_TIFF=ON -D WITH_UNICAP=OFF \
#-D WITH_V4L=OFF -D WITH_VTK=OFF -D WITH_WEBP=ON -D WITH_XIMEA=OFF -D WITH_XINE=OFF \
#-D WITH_LAPACKE=ON -D WITH_MATLAB=OFF ..
###
#RUN make && make install
