class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261106-git-23762d0.tar.gz"
  version "0.4-20261106-git-23762d0"
  sha256 "d8624c8e88790d4206ddd8246db5de535573153de134f624dcdc297f40c1a6df"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa07babfe02c02797830160c07c166aafb263a89b4691aafbf0f4bf01ac7956f"
    sha256 cellar: :any, arm64_tahoe:       "77c571b3b318db8eb87ae2fed8b6e5ad287402cea1e0f4d34298d9f4079a0081"
    sha256 cellar: :any, arm64_sequoia:     "6579377845d4bfcca64edf3c655a79a23702b50a554ef0b5c52e0687bf048620"
    sha256 cellar: :any, arm64_linux:       "5b3e30ce0c277ca9681073716d0e6ed5d5f62e6fbd6568ea10c43c031e43f37f"
    sha256 cellar: :any, x86_64_linux:      "d6110911157119115a4d316a5e20d9b2856bee1d9ed80f1c3d7c373b9514cf33"
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
