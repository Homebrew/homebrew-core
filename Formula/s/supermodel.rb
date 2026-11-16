class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261116-git-e9e07c1.tar.gz"
  version "0.4-20261116-git-e9e07c1"
  sha256 "6fbbc549a705d8707b3b4ba7b3be4b2f37e417f70e014eaa2bbdb676508a027c"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e247a14dd74a7ce9d27ccf7c5d0088e11be8300cfc7811f7b1a3dc60311a7fc0"
    sha256 cellar: :any, arm64_tahoe:       "1e7d55d63fec7998cedf4198d094ae5414c232e48c07ffd6d9c9a84e7cc3b7ac"
    sha256 cellar: :any, arm64_sequoia:     "3076de0912cd3fb85f62d2dc989f558609a0ebc9d2cc762963e32084b1b3275c"
    sha256 cellar: :any, arm64_linux:       "f430becd43cbc8c0b4c7150516b7ba0e5162d37b0dfc4995dcf2ee053cc27bb5"
    sha256 cellar: :any, x86_64_linux:      "04c9bce37ecc875e25b2e795f3367ba253fa3ebb50bff1655e7e70520216c460"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Not using Makefile.OSX as it uses prebuilt frameworks
    system "make", "-f", "Makefiles/Makefile.UNIX", "BIN_DIR=#{bin}"
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
