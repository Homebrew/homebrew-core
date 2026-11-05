class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261105-git-63138ac.tar.gz"
  version "0.3a-20261105-git-63138ac"
  sha256 "f0827689af5ebadae9df0f0787f5d740f3fd0355c0977c3ffd512a4ce2a8b3a7"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "694c70b7e2a9f50e3bbe158675d5d158efbf381de1287e22bffb1d9d0d398c05"
    sha256 cellar: :any, arm64_tahoe:       "511ce8acfc3ab2f2a10515377cebd0eaca2226170bff6e11270e470a92245277"
    sha256 cellar: :any, arm64_sequoia:     "939b154a41fe5a46b81aaed85226f02c8eb36db034918f2803e471ac6ee64a26"
    sha256 cellar: :any, arm64_linux:       "06a3b548a29b67163941fac179541c034cb53e2b0fd9d2e2aec74b1ee93b3167"
    sha256 cellar: :any, x86_64_linux:      "efd401e4cdb73bb76b92ed233edd2c18bf2da9607381f608953652402c6a08fd"
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
