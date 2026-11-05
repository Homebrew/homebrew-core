class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261105-git-63138ac.tar.gz"
  version "0.3a-20261105-git-63138ac"
  sha256 "f0827689af5ebadae9df0f0787f5d740f3fd0355c0977c3ffd512a4ce2a8b3a7"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "646eeba22028d671ea983eb4d380de7e6c259062fd51c3691f2e2fc17f09ef54"
    sha256 cellar: :any, arm64_tahoe:       "6014bc6a90817b8ce2eeee50ed9b3e8289085845a2918f79e0147273f1070c4b"
    sha256 cellar: :any, arm64_sequoia:     "d57fc4cc712da804c0ba9e2f614e54bf33eff631401c1a538d1076c6cd19832d"
    sha256 cellar: :any, arm64_linux:       "66a1f87c06629a056dbc4843a3693d12b482dac01f6d9c758aca5a06942aab3c"
    sha256 cellar: :any, x86_64_linux:      "8b6c4dfbd493223b109543d599a5e6e1f7e0557f13f75d68b84a2058462db976"
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
