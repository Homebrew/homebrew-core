class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  # curl: (9) Server denied you to change to the given directory
  # ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/sgrep2/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  bottle do
    sha256 "a9035c893dcfb8a82a7e2976774645af26dc4f1ade1f2af225264a35695ebda4" => :mojave
    sha256 "0e46d1884c4ad14911e32952b3f1e2df1457b455a30ed06ee67dfb5e33efd469" => :high_sierra
    sha256 "c698f6a657fd7edd7bb8e7d717dc09ac73b1042e93b79555152626f71388b275" => :sierra
    sha256 "089890a739b047b429b88a583f71832fbfbd3c8f7abc067531424c14e8463df4" => :el_capitan
    sha256 "a4228a3f40db355cbd6b3feedd4cbdaf8c9b582b24f188982f296b17ac14590f" => :yosemite
    sha256 "f582b8ae918c1f279e1e3c362d016ad91aeb4accc229cfe9f6ccac8c991ce4a6" => :mavericks
  end

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
