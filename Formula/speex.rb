class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"
  revison 1

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended
  depends_on "fftw" => :optional

  def install
    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-sse
    ]
    args << "--with-fft=gpl-fftw3" if build.with? "fftw"
    system "./configure", *args
    system "make", "install"
  end
end
