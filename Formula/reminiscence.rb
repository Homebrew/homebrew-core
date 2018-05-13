class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.3.7.tar.bz2"
  sha256 "3e1b9d8e260e5aca086c4a95a833abb2918a2a81047df706770b8f7dcda1934f"

  bottle do
    cellar :any
    sha256 "afd2cd157db08a099a133474d2e39cfa0a84cf0f964f723d08e1c694150ce9d2" => :high_sierra
    sha256 "1d7ec41316c4356bf9563e2b1edad2ebb360d4d2aee3b10b4f3cc3549572fffd" => :sierra
    sha256 "5def6d20b975e17c0d988714efd1023b618594df8d7ab8f2fd9092df6ac35221" => :el_capitan
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
