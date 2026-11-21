class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261121-git-34ede1c.tar.gz"
  version "0.4-20261121-git-34ede1c"
  sha256 "f5e65d20c1bb3b7aac4da6f4b3c4b95ef077ed0f6da7a958e0f2f5bdead469fe"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "e019d62c7161d74d24f045214d6d3c00dfff3d2b9edbaf80a8d7ff94713a3d66"
    sha256 cellar: :any, arm64_golden_gate: "83e1d15d0cdde22880f3887a72d1a28e683c04c566b6092315806d0036955a1e"
    sha256 cellar: :any, arm64_tahoe:       "db2cc926db4795ff65556cbcd3380eb25093d5797fe4fab09e7c495d54fb8780"
    sha256 cellar: :any, arm64_sequoia:     "7fd7b646be147a34ab203aef67baa9f66c600be1d21d608736925a13a748c319"
    sha256 cellar: :any, arm64_linux:       "d9d52b1f662a4cf12e3a75ef0e1b0afe3ac0e7660eb4e09b48cc35a0247c7bc6"
    sha256 cellar: :any, x86_64_linux:      "28fd39fae7cd963146301c2f6175fc41b0ca46eb6a88120078d337b91e046ba3"
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
