class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.4/tin-2.4.5.tar.xz"
  sha256 "1a14e6a49a3627230f792eb48936d39d0abd7b04d958083a6296bb4210c6c512"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    rebuild 1
    sha256 "1c9c260926726183ef975425c557afbd9be80a2cab7eb2258d63945716153980" => :big_sur
    sha256 "051423dd86f4bf45e3584e8aadd838e46bcc006c7322e7471b1158f4c156c84a" => :arm64_big_sur
    sha256 "b3e2e78b8e6d0db0d04cb036454deb8bc718fb1c7cd489924ffcc548eacdeec4" => :catalina
    sha256 "1170864e0be31fee55f0a49993e5d40908eafe0c8ed47eee2087236ad17ab988" => :mojave
  end

  depends_on "gettext"

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

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
