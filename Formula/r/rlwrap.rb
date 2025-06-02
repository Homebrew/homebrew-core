class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "9abb0a0dc19e85794d9b8e72e480530563eb4ee1bf243e87c0e0dd05ea4a2f09"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "906fd4f2ac755fb709b34489cfbbfaf5fca3ae746d264f5f3348105721c9a367"
    sha256 arm64_sonoma:  "587dddf6ead7b200929b507550c2b1e1ad309f8fad2d979a15af7a572cab22c3"
    sha256 arm64_ventura: "f447017ce6f993fffbb881bdeb5c82de9c3fd172f3732240ba3b13e0a1a47505"
    sha256 sonoma:        "7e552c35f02259d75f68e98086d02374a2f5165eba4cc96ea15ec3e072a70ef5"
    sha256 ventura:       "a9c4c978ab08e6cdafbf80ee9c1298c84ca24bb05587f80574ddc69992a15d19"
    sha256 arm64_linux:   "1af86f576186eff68c58e5b598439bd7b13767dd359084eb87f12bdf4bd024a4"
    sha256 x86_64_linux:  "172eba8bec2d2771dbaa277417b499c878fdc8dcd0c71957f89489d794f70832"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
