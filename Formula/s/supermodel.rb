class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261106-git-345c3ad.tar.gz"
  version "0.4-20261106-git-345c3ad"
  sha256 "d9fdefed6f91bdd0a002b18f0e674b2e9b19358f4987d87708a9754e3eb1cfbd"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "674c52c1668ea892d7e3372604d06cc94fecbf8183d3af8dbb1177716a665a3d"
    sha256 cellar: :any, arm64_tahoe:       "4f6eda61f8c86e948a41ba80b5ee60d085f84340dda0ace0c0f342d962744565"
    sha256 cellar: :any, arm64_sequoia:     "9bb2d1087264e920c917fd905f89c23c00cf2f95b482d079b14651e3ddb340cb"
    sha256 cellar: :any, arm64_linux:       "401049e0784f3584f6b149da400d19a1e74cb382ab2bcbc9d08978993a1d4bff"
    sha256 cellar: :any, x86_64_linux:      "9574e45eaccf885f3235b7c72f557c01374bb0d873650926fd6caf7a0056e776"
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
