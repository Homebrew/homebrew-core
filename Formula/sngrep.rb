class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.6.tar.gz"
  sha256 "638d6557dc68db401b07d73b2e7f8276800281f021fe0c942992566d6b59a48a"

  bottle do
    sha256 "3715ca732df699b3165f4410cc4939e7d13502204b76ae31e6d31acd29efcd91" => :mojave
    sha256 "23e8dcccf8484a80a81090041559dd4c327d85e6e9ade7d15aa375e613741a4d" => :high_sierra
    sha256 "30c2e61accbce75df643a13be8ac64dabf6cbe5a9edcb48d932dee339afbae19" => :sierra
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
