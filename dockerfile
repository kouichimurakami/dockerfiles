#利用するubuntuのイメージ
FROM ubuntu:16.04
#update
RUN apt-get update 
#wgretをインストール
RUN apt-get install -y wget
#curlをインストール
RUN apt-get install -y curl
#dpkg-dev g++ gcc libc6-dev makeをインストール
RUN apt-get install -y build-essential
#CMAKE3.6.2をインストール
RUN wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz && tar xvf cmake-3.6.2.tar.gz && cd cmake-3.6.2 && ./configure && make && make install
#gitをインストール
RUN apt-get install -y vim
#vimをインストール
RUN apt-get install -y git
#-dev開発環境ツールをインストール
RUN apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
#python3とnumpyをインストール
RUN apt-get install -y python3-dev python3-numpy
#C++をマルチスレッドで動かす
RUN apt-get install -y libtbb2 libtbb-dev
#JPEG形式、PNG形式、TIFF形式、JPEG2000形式を扱えるようにするCライブラリ
RUN apt-get install -y libjpeg-dev libpng16-dev libtiff5-dev libjasper-dev
#IEE1394規格に準拠したカメラ
RUN apt-get install -y libdc1394-22-dev
#zipをインストール
RUN apt-get install zlib1g-dev
#pkg-config ビルトの自動設定
#RUN apt-get install -y pkg-config
#C++のGTK+ライブラリを利用できる
#RUN curl http://ftp.gnome.org/pub/gnome/sources/gtk+/3.20/gtk+-3.20.0.tar.xz && tar xfv gtk+-3.20.0.tar.xz
#RUN cd gtk+-3.20.0 && ./configure && make && make install
#ffmpegをインストール
#RUN wget https://www.ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2 && tar jxvf ffmpeg-snapshot-git.tar.bz2
#RUN chmod 775 ffmpeg && cd ffmpeg && ./configure --enable-shared && make && make install
#
#
#
#
