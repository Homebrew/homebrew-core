class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.4/tin-2.4.4.tar.xz"
  sha256 "9ff12cecf6005be4d150a26403cb736668bcedbc97fe7d6e6846559ea490ff02"

  bottle do
    sha256 "2ca10c400074c9b3ec7fe56bdfd5acb638bfe2d417459971090e85d95118bef6" => :catalina
    sha256 "e8fb724dc37c9ff8cc7681ca5bac7ee335e8636f57482171ed4f3c31a59bf066" => :mojave
    sha256 "e9b2afbdc37d3a349dd8341e7ceb1191466b28fc9e636ef15308d6c5b7075ba4" => :high_sierra
    sha256 "7964b2236af4b8c195271238b66a054293d94ce5bda3f10746f0b8e1d06c9f91" => :sierra
    sha256 "572e6d081547a2b9fc46afffa994f52ffd5696be884e18858c8c03131a72faec" => :el_capitan
  end

  depends_on "gettext"

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
