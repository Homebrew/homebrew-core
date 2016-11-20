class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.1.2/tcpreplay-4.1.2.tar.gz"
  sha256 "da483347e83a9b5df0e0dbb0f822a2d37236e79dda35f4bc4e6684fa827f25ea"

  bottle do
    cellar :any
    sha256 "ab4bf20934207921bfbe370d620098c7a41aad6722f9bd124591e56294569fe2" => :sierra
    sha256 "bdef98f3c5bfd5daeb2d99c2361ef3be11661c37acf19536ed210b4a2cb5ba89" => :el_capitan
    sha256 "6faba215d8a394c2761476661c5e62cfff8be36068a71e28c8562d2a7da1286b" => :yosemite
    sha256 "fb831dbf6c074d5b1f639a22711428610c8e99c396637f2b2014eadb32953060" => :mavericks
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
