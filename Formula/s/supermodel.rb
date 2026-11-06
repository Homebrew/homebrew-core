class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261106-git-1b4b752.tar.gz"
  version "0.3a-20261106-git-1b4b752"
  sha256 "7c96fae6c478c389d99dad4e8c5faf5a10426dbf23193e689884a06fc6ef5932"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ce7c7da6b181bbcd3aef6701f03cfc15927d34970b302ad3f845f0cd91cf8fa"
    sha256 cellar: :any, arm64_tahoe:       "6f23aa79d9f8b5ac771eef2d664c1eb3ef8f3ce4bc9b8ac8eed9080d2d336b5e"
    sha256 cellar: :any, arm64_sequoia:     "369f00b67964726ffd5417094dd81a46d86b45bf4a1d5d429ceb37038cf41f5d"
    sha256 cellar: :any, arm64_linux:       "b310ca1796ca723e0f0b895a22ad8c64dc4a4de3761eb007a03f54958ee83010"
    sha256 cellar: :any, x86_64_linux:      "147e644f34dd1c1dad8981f3fa124d152482861548259ef935d620c5f89084a1"
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
