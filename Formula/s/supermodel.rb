class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261128-git-7941f42.tar.gz"
  version "0.4-20261128-git-7941f42"
  sha256 "2c6c34514f7583892581441f78b6456a6427ef6d9a875204e53caae15bdb1d14"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "fe45b861da95de18b02206f76b0b408cb6de9a8bc5c6b47185e6ef74e3ca3205"
    sha256 cellar: :any, arm64_golden_gate: "67ca3388b6492c8330101a34366a36017100f80562e5faa8e5322da03d996281"
    sha256 cellar: :any, arm64_tahoe:       "0492fa7a1da6b917322b2b069a19c1cfa4847be7b100f9fe4db91d3c47d28417"
    sha256 cellar: :any, arm64_sequoia:     "19c5d5c341d17f11542fa1bf167d19e5e724d3b419f784f57f0347e0897eb56f"
    sha256 cellar: :any, arm64_linux:       "ff2cdaf07e6a31d0172c09b6a59d4bca5b92f64263a33262dcd5d75f3f006c37"
    sha256 cellar: :any, x86_64_linux:      "f2226ded4a78f03d569ab14fe5efeaa608719e70f1727a22e3cd7680b7869c80"
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
