class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.43.tar.gz"
  sha256 "29e5a850fbe4753f353b0734e46ec0da043621bdcf7b52a89b77517f3941aade"
  license "GPL-2.0"
  revision 1
  head "https://github.com/hanslub42/rlwrap.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "d1569b44bcf5e3cbc42a6c9e456ad57a56cdf2906eab3a7ec837f5e83f3e838c" => :big_sur
    sha256 "1749685e3fdae4734269eff4de64dcaf09d5aaa0664998f2f6061918d05167a6" => :arm64_big_sur
    sha256 "d4a2ef8e6f2c143c9156ed301d9b835b74b8e1c8bb232feb7fd8494e5262441c" => :catalina
    sha256 "1bd82e889c7f88df7b45b31201d563d7185c362c7a5d3814b5474d295de65f22" => :mojave
    sha256 "d8d5c5402f1b0041bc26c2161b2822cfd025e93674a7a5dc0046185d5870181d" => :high_sierra
    sha256 "3dd6233bbef1327553b5bd92d070c4d7bd24f5414628c1c367c4c3ad6f1acc76" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rlwrap", "--version"
  end
end
