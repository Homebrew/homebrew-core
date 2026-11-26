class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261125-git-739ef99.tar.gz"
  version "0.4-20261125-git-739ef99"
  sha256 "2f932d3021db672bf0f261379374e1ec3ea18daadbe66e9c14acc056f1e53b0f"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "e489c399f49dc7faaac1fb450c5272fbc83fd91fff8e257dca798e1a5b57eed5"
    sha256 cellar: :any, arm64_golden_gate: "70fc2774209f162dbf4039e9637d2b600457197f1c13531e3839ce0d1d8fcb3c"
    sha256 cellar: :any, arm64_tahoe:       "b07643323a10ebe81becfdb62d1468dea95b4c5a5e854d66dc0500b1d3c9b2a7"
    sha256 cellar: :any, arm64_sequoia:     "aac62f4e8fc8ea71509c50def444ac1ac3f96cd56040d979a0a89b0b4e7fd77d"
    sha256 cellar: :any, arm64_linux:       "c3ba0a49679531ce30f9196628512b747eb4bff10e476d5208e4d689f4942a7d"
    sha256 cellar: :any, x86_64_linux:      "ec1641536df6f30f916146ae5c31416403be19b9c7a66064e7645328b99ee3ef"
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
