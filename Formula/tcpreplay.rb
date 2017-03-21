class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.0/tcpreplay-4.2.0.tar.gz"
  sha256 "924f80cd1958a4c4447f0a6a54e8d3af7aebd3674aa4ef9973f69b43b1675221"

  bottle do
    cellar :any
    sha256 "34d2cfd1ed56a88cca3fd312753e62c58794e7ceb0c26e76f78b874687cd90d3" => :sierra
    sha256 "ca612c298303139b0367532ed670e62abe6ae19b8b2c1e15cddba759b90a04a4" => :el_capitan
    sha256 "abe3cbe315a9f0d0091ac11320afa48261fedc989d25915aac4f0aeb1c575071" => :yosemite
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
