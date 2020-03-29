class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.4/tin-2.4.4.tar.xz"
  sha256 "9ff12cecf6005be4d150a26403cb736668bcedbc97fe7d6e6846559ea490ff02"

  bottle do
    sha256 "78c9d679c6669f6e9579c1de58e1769f8d5fdf0de54664aaeba49888811d33a5" => :catalina
    sha256 "2fb85a878a4930f0d48a35fd3628621d5d0f3009d8283066ddfdc17a950153b8" => :mojave
    sha256 "89b38a18627bac3b16f2c947350ce3e438793603d04b30fc09bea916f85cbd49" => :high_sierra
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
