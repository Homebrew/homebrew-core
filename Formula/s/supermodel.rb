class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261113-git-2806f14.tar.gz"
  version "0.4-20261113-git-2806f14"
  sha256 "7bdf907d8589704d170451333cd72ce58103b27369e9455c22118968037be8b1"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4f2147298cf1bb17efbd1b34c51a285f389b067a9d76b5b9d1ee26e4d6d2a99"
    sha256 cellar: :any, arm64_tahoe:       "a51d2ced4464c55898604ade5f38449b51ce0a96559e6695e631d9e22af8e553"
    sha256 cellar: :any, arm64_sequoia:     "6dbf18c4cd7e4997181d88e2bc4b20aba28ff406eecbb433bb0dfadbc2ab6f05"
    sha256 cellar: :any, arm64_linux:       "823dbfc2623c3c78c947979f169c5c8ea100b56b5557edc97fcff97465f384f1"
    sha256 cellar: :any, x86_64_linux:      "f516358ae4c49396732c5bf033eec6c2cb21efa98481314a46cb8b40139731f3"
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
