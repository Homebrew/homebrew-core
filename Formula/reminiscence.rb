class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.3.5.tar.bz2"
  sha256 "0d2d768eb986f39060783cfebeb68ab352fca9b941e410cfd3e44d5254dfd1d9"

  bottle do
    cellar :any
    sha256 "a77388ff62558bde36135b4232c467330a97ccabe7d990a87f7444c2efed4439" => :high_sierra
    sha256 "c89d69584a6f3953e2685d5985fae2fa27dcc1b0255cc128448dda91888e5e25" => :sierra
    sha256 "9388f64555aef94359c0e0c8082814fad609cf3d5c78b6f991851d8a62ee1576" => :el_capitan
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
