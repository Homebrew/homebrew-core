class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.43.tar.gz"
  sha256 "29e5a850fbe4753f353b0734e46ec0da043621bdcf7b52a89b77517f3941aade"
  revision 1
  head "https://github.com/hanslub42/rlwrap.git"

  bottle do
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
