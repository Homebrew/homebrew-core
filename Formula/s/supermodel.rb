class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261108-git-239a77b.tar.gz"
  version "0.4-20261108-git-239a77b"
  sha256 "5a9d0679b6b806013603562f8e5c3cfec835209aa8490491946ec79bdf60a4a2"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "29fd5a7af7bc4819c2a78c21a73a6a03537719739b96a425a2a0474d9e960a19"
    sha256 cellar: :any, arm64_tahoe:       "17e16532a633cb5d48f5a2fbd583c5aae7744758f11db48b50c013072f02d440"
    sha256 cellar: :any, arm64_sequoia:     "f238300639c95805e6474ddefba50a9c0d6c2c149e7317718ca4902c7b79d252"
    sha256 cellar: :any, arm64_linux:       "ca36a3ad361ba1986ac000159f4d30e1857e76891f2732f3e63957a4366515ab"
    sha256 cellar: :any, x86_64_linux:      "3f7ee0ca934c9419ee41dbb7424bb5d206cddd2ddf1abe8eb29471e174330b71"
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
