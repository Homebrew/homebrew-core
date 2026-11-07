class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261107-git-d0cdfa1.tar.gz"
  version "0.4-20261107-git-d0cdfa1"
  sha256 "f70bdabc97db4cded835edcebf1047d5621dffc6ddf1b27de79293b89b96d7b5"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "91944d205216ab6173851bddbfd84855580651bd300a8e16149cc093f80880c4"
    sha256 cellar: :any, arm64_tahoe:       "090fb15c191926d41262699f088309c03ac9ccabc626d39b7bfef3fa3c4e7fe2"
    sha256 cellar: :any, arm64_sequoia:     "f88c28ef673dbea1d217bbaee77c7fed58226384a4d717728973d9062c77c642"
    sha256 cellar: :any, arm64_linux:       "74b7803c32678f1360ae1ba8548c958068ead0c9eb5147e8e32dd34fdfb00556"
    sha256 cellar: :any, x86_64_linux:      "4ab43ba4d6bb14ca62fff7f765b6b8db60f7e26cb46b174942555d242b6c47ff"
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
