class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/refs/tags/v0.48.tar.gz"
  sha256 "b2721b1c0147aaafc98e6a31d875316ba032ad336bec7f2a8bc538f9e3c6db60"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4caef889ab3bee246054ca4857517e098960d4be9ff556c5c545d3f7170b2b1d"
    sha256 arm64_sequoia: "2cb021c30b2503d34599d69ff0c9d1950c73018ab7736b53e1d3c77c932e191f"
    sha256 arm64_sonoma:  "ad9622f1007c86f74f61f0b3eec75e28e564aeec60d3f7b858d2cd26d2c3106d"
    sha256 sonoma:        "7c3435731fd7e0a80089fa9d72d83715c19e953dc3e8cfa61d539a0393ff0700"
    sha256 arm64_linux:   "305d08434011dd7bebeb463ac8bfc314b78d38a8c81371a33210b2bd12b74580"
    sha256 x86_64_linux:  "6c5a1f7a230f7987b1b78f5cea9c34afc36ec4bdaa7bca0bdb30fd321359d6a9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libptytty"
  depends_on "readline"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rlwrap", "--version"
  end
end
