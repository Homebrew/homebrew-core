class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.9.tar.gz"
  sha256 "41cfb4e1cacf2e94e52aa8f7edd3c7e1902e3d6be998ee007ada570d8b1146cf"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?wumpus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3d3dd70c7e51fb37a91045f44dc229173d0f19ae86bd78e2a5384cd7ee54b34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "372fecaade15d59382721760067f03f049d54f59f9881f2e607cef6f41738064"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b44ffe5c362b951f60bc3d9c1f85ead53ce8b719d6576c0a3ed149533c03d135"
    sha256 cellar: :any_skip_relocation, ventura:        "48ef93d16c2a23d054fef94bee5d96c350575aa592406551a31152b6e5cbb4e0"
    sha256 cellar: :any_skip_relocation, monterey:       "91855ad6e374529fbb0d1afa7ee9d43a1341f4c34fe61358ec8875e5c7e45b8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "61beb0e786b6dd643c73193ab7316af45a72a91fc3771f3b06e79b0e11ec463c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa32a9e09d3b96fe8d4c7d86be19674a5a0996aa233d41cfb2632b1e40ac2669"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match("HUNT THE WUMPUS",
                 pipe_output(bin/"wumpus", "^C"))
  end
end
