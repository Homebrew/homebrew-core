class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.3.5.tar.bz2"
  sha256 "0d2d768eb986f39060783cfebeb68ab352fca9b941e410cfd3e44d5254dfd1d9"

  bottle do
    cellar :any
    sha256 "002eb378f1f32e0360b6c87ac9cf9f3448d1fb4645aaa16b5ef2dbaf50d551f9" => :high_sierra
    sha256 "db8a0cde02a3b4300ad14c5ae68a8c948eb36b42b1f5e9044563d98cd47176ae" => :sierra
    sha256 "72fc5d199d3ebe848911fbe02eeafa64d3d3b38f063e997e4a5176ef02bca81b" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  resource "tremor" do
    url "https://git.xiph.org/tremor.git",
        :revision => "b56ffce0c0773ec5ca04c466bc00b1bbcaf65aef"
  end

  def install
    resource("tremor").stage do
      system "autoreconf", "-fiv"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--disable-static"
      system "make", "install"
    end

    ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
    ENV.prepend "LDFLAGS", "-L#{libexec}/lib"

    system "make"
    bin.install "rs" => "reminiscence"
  end

  test do
    system bin/"reminiscence", "--help"
  end
end
