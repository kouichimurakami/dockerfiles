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
        zlib1g-dev \
        checkinstall #opencvをaptで管理するためckeckinstallを導入
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
RUN apt-get install -y libgtk3.0 #libgtk-3-dev libpng++-devi
#OPEN-CVをインストール
RUN wget https://github.com/opencv/opencv/archive/3.3.0.tar.gz && tar zxvf 3.3.0.tar.gz && cd opencv-3.3.0
RUN git clone https://gist.github.com/0aea057af98dcf5a838da23becfdffbe.git && ls -al  && cp /0aea057af98dcf5a838da23becfdffbe/opencv3.2_build-ubuntu16.04.sh /opencv-3.3.0/opencv3.3_build-ubuntu16.04.sh && ls -al && cd opencv-3.3.0 && ls -al && sh opencv3.3_build-ubuntu16.04.sh && cd build && make && make install
