class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.3/tcpreplay-4.3.3.tar.gz"
  sha256 "ed2402caa9434ff5c74b2e7b31178c73e7c7c5c4ea1e1d0e2e39a7dc46958fde"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "a4b41c27929bfd52016d1cc576089a9cb42dfd0e595c3078a40b26bd39fbd65f" => :catalina
    sha256 "0ec1b2260c108d103d4d594a8fff9482656833e5308690b90c5ef0a05a155546" => :mojave
    sha256 "439ed368cf28fb710cefec00f88de8d32e0d039abed0f8761f1a1ae4731dac53" => :high_sierra
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
