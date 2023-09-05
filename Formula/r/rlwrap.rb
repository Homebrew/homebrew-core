class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/refs/tags/0.46.1.tar.gz"
  sha256 "c537e8a53df36f1f996601d776203478ad56fab1d67b3c1a63057badb0851cec"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6cc64e120040bde8ff3680d02a5233073756f3a9ecfa159230636574747be809"
    sha256 arm64_monterey: "800128c200ac5cd3ba45d50a835bd48f9ffb62e04886d1d615604477a599b91b"
    sha256 arm64_big_sur:  "4273ede2a9d3c9c7812e596db58b7ec36446fb9e26d9fcbe908f8afa68cf8672"
    sha256 ventura:        "9e480ae1326e022bbec1454240504e1361fb8b62c9df64b378f5072d6e27fb35"
    sha256 monterey:       "073698b12b6cb3cb5bc9934bd1b0048562ba32b320fcc2cef9b5652b7354f825"
    sha256 big_sur:        "b4b03c2fa68bfb2210e7fda2153bc6a6866ae3c16105465d14818e3ea87795b6"
    sha256 catalina:       "a46ae39723ca361493eb0b81e15cd85de9a2b0b9ff26d8de49d0f606b328658c"
    sha256 x86_64_linux:   "d8ea0283b1103d38b58122b54334229769b61fd78cf1d9f1d4716437389cbc3e"
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
