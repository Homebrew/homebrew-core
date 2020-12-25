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
    sha256 "88a9d57f952f8780b7d40b09a48a88e72a13d5d7a363ff77b9714571127a40f0" => :big_sur
    sha256 "a95e73413077bf18a72f0b3d79452bf5391e95974e1a89033eefabccec428bf8" => :arm64_big_sur
    sha256 "78c9d679c6669f6e9579c1de58e1769f8d5fdf0de54664aaeba49888811d33a5" => :catalina
    sha256 "2fb85a878a4930f0d48a35fd3628621d5d0f3009d8283066ddfdc17a950153b8" => :mojave
    sha256 "89b38a18627bac3b16f2c947350ce3e438793603d04b30fc09bea916f85cbd49" => :high_sierra
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
