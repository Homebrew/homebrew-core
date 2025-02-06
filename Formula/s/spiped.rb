class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.3.tgz"
  sha256 "70c53070dbbb10d1442754aeafb01b08ec829203d41023647dbf1a1435ee4a65"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c31907657edcfb9dec521b0ca330612a8b0a2a6a9f6f79331044cdd0baec77f"
    sha256 cellar: :any,                 arm64_sonoma:  "252282f9a5384400771e8854713143189eb7fb061947d930fda82efe822dddb9"
    sha256 cellar: :any,                 arm64_ventura: "7f546c81a7e7c012ad855cbc1a7055e3acf46fcd2aaf973b017201d163974295"
    sha256 cellar: :any,                 sonoma:        "aed8dbc299b2a6502228e4d63e75fc593a5c750a43461f0c12ee982ddd372ff5"
    sha256 cellar: :any,                 ventura:       "00e199c37e2d219b7972f2a11b2c8db2880e1a964bfa6e01b6dcd07c6aca1e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de32ad6acb5f5220209bfa0a42d34e32af122eb5b07c02833ca04d35b637dfb2"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "bsdmake" => :build
  end

  def install
    man1.mkpath
    make = OS.mac? ? "bsdmake" : "make"
    system make, "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
