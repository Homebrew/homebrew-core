class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.43.tar.gz"
  sha256 "29e5a850fbe4753f353b0734e46ec0da043621bdcf7b52a89b77517f3941aade"
  head "https://github.com/hanslub42/rlwrap.git"

  bottle do
    sha256 "689b716c824586bdd0399f0acce9271417222436b387862567dc9d48aba2ece7" => :sierra
    sha256 "b0548979bc62fadccf1d3f6f13f0df1c851e30e4d282d7ac20f9936f3e4b975f" => :el_capitan
    sha256 "7b8a163bb614b481b88a627ad9a579e5b0acb24deb736ccea02da2606b6dc8a0" => :yosemite
  end

  depends_on "readline"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
