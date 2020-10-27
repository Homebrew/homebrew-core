class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.7.tar.gz"
  sha256 "3c96aadd8b8c6b7adb5552d6fb4234f2000f15109b0f6c5feb632c81306cc49b"
  license "GPL-3.0"

  bottle do
    sha256 "28a9d6bf75bdc1a95d3878b0f081abf44d743d916b6d15a9ed4dba2a872b6cdf" => :catalina
    sha256 "5e75eef195f7bae03c030391f4f21f5ab5f1eb36e444a90d70833eb40e8cc4fb" => :mojave
    sha256 "03b884145f781a12ad892765a61f743093fc2477f51faff426c7226d6617ed2e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
