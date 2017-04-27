class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.4/tcpreplay-4.2.4.tar.gz"
  sha256 "da78ea1a1fe8ff177a4f9e71c4c6739b79ac86db2c2bb90955318b8e8439beb7"

  bottle do
    cellar :any
    sha256 "93405500e64240e1a1c3f3cd7e490d001ad5a527e4534ffe86e4e10732362537" => :sierra
    sha256 "1ea477755dc90dee3a6c2e1e79ca0ea3988b2c9192eee13574b3731ea9bb29db" => :el_capitan
    sha256 "21cb8b305b6b6c87291e1ad8fae29aebc96c6d543204a993ba67e436a8efb46b" => :yosemite
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
