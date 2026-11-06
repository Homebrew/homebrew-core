class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261106-git-5db27c3.tar.gz"
  version "0.3a-20261106-git-5db27c3"
  sha256 "c8f762e4de1f33309fece83bd0c02e01ad3e8f3149780c705dba4b7b9fead8f4"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "32a9521d49e78a6e0fa1c05cbb4b0b7eeab27179da5f5cced7bc4f3b2f419e01"
    sha256 cellar: :any, arm64_tahoe:       "9d935a43048d291b9d88dea45562ad58eb576bcd0ad44396c221bcd63309a195"
    sha256 cellar: :any, arm64_sequoia:     "78c184c97ad193c91506cc8def70ef623c726533b26c7b19b1a1906a6dc22110"
    sha256 cellar: :any, arm64_linux:       "f2b73873306c75a1a30585c47215fcf6c44301e0c4a23aaaf4bf51d943a3766a"
    sha256 cellar: :any, x86_64_linux:      "66bbbc16132a93752eaf3448ed85d519c6e7a06e1d395197e67f9dac7650bc04"
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
