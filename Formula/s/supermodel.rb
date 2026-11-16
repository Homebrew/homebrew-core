class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261115-git-70451cb.tar.gz"
  version "0.4-20261115-git-70451cb"
  sha256 "c7c8bf6ba1d4b6a5b2094870e0a2b32862ac7625fb6adc4bf15da6bb1e8f8ff4"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5f913962c0f3e9b97d843fe65c1089471344767f1de79856f63654ba0c712381"
    sha256 cellar: :any, arm64_tahoe:       "bdaf82b02902a0af149d813e7fb6185a7f0e17c698b397f744ecff288b2cf37b"
    sha256 cellar: :any, arm64_sequoia:     "01adbf38f9f628abe218e1f6b63098a22c85f19669db51cfdf27f8d8d912e9a7"
    sha256 cellar: :any, arm64_linux:       "7082391f24a1512e3f64eb7ae3ac3e3159fdbc5c7a6e72dadabd38619c7c7f4c"
    sha256 cellar: :any, x86_64_linux:      "e01780cafad6553a2a7178c51bba0f0443ff8ebc96c216b531c45f385192c479"
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
