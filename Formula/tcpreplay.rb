class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.1/tcpreplay-4.2.1.tar.gz"
  sha256 "224b519e561d969b4bdb0e700c2283e036620e3cb5895d5aab2a7e4f27d21a79"

  bottle do
    cellar :any
    sha256 "0158b6b6ace73323a16a7e3f4a9bb04085aedf4664daf422c8c95f43906b59bf" => :sierra
    sha256 "dd7ffb1f76c2403927ef033743b6e2fbd8b7c51b20573aa01496a9e5b61d6d61" => :el_capitan
    sha256 "3cf78f7ddb86398a1b59fd80a536199e9bbb216f677e741f4bbe15fb542172a7" => :yosemite
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
