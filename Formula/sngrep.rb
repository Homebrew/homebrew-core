class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.6.tar.gz"
  sha256 "638d6557dc68db401b07d73b2e7f8276800281f021fe0c942992566d6b59a48a"
  revision 1

  bottle do
    sha256 "b69d241b348100f9f4b7c47cb0b98a1cabff37b4a71c89eedd8cf44e1a9f32be" => :mojave
    sha256 "29816924ecc7e66f7b61195f56296250212cf6122a720b49b60735b1816f4b74" => :high_sierra
    sha256 "e87ebce2a16736e8037200cc4b797aa603f67751adfe17fefed1139db9723abc" => :sierra
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
