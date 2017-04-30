class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2rc3.tar.gz"
  sha256 "e8be7482df7c95735e5466efb371bd7f21115f39eb45c20ab7264d39c57b6413"
  revision 1

  bottle do
    cellar :any
    sha256 "367e34d4ba6e7087762193a18910da38905496ec41c0f329604d310a09e4f5ed" => :sierra
    sha256 "4891bd2a89fc9369d9c573afd80a1e7593e9414a0d6a956921af1b65f61ab264" => :el_capitan
    sha256 "34a342effdc414829a7063d4b8dc7f2bbfa2d37231904f4fa6784c38d90bdb3d" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw" => :optional

  def install
    ENV.append "LIBS", "-lfftw3f" if build.with? "fftw"
    system "./autogen.sh"
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-sse
    ]
    args << "--with-fft=gpl-fftw3" if build.with? "fftw"
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
