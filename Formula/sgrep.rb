class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  url "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "29e528a52ae36131ded52bb08d9cf9b12b1455fbc715f7b7bbd3b97f637862e5" => :catalina
    sha256 "bfb1f484dd474727fec463b1b90ffe7250f5c82e0e65bec96903e38f6e0a8e48" => :mojave
    sha256 "a243589e79a4cde4f7bba21ec618e3c323c049589707bde6e2c20c4bf1014464" => :high_sierra
  end

  uses_from_macos "m4"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end
