class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.6.tar.gz"
  sha256 "638d6557dc68db401b07d73b2e7f8276800281f021fe0c942992566d6b59a48a"

  bottle do
    rebuild 1
    sha256 "f54b59619034b13fbb2335ac87bfd530d2fd757ea12fc9e7c680c04957a83ac5" => :mojave
    sha256 "60ef7a7f63a10751d57000321b84a24e37e491f55ffa942b177ee31a9a79275c" => :high_sierra
    sha256 "b19e1624c118d3fa101aec7298ce707bb8fcef10376b85adaf80ab248df2b511" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
