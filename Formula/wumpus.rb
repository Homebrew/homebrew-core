class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.7.tar.gz"
  sha256 "892678a66d6d1fe2a7ede517df2694682b882797a546ac5c0568cc60b659f702"

  livecheck do
    url :homepage
    regex(/href=.*?wumpus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c30d039fdfa46df8f14bf9f881b7bf07e33405f0eb0a1d3c84007b66a3ad06d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e1c53ffe64c591ac7e32ffe612d86a043588d0b6d5f63e0d8091dbcaa8af6d8"
    sha256 cellar: :any_skip_relocation, monterey:       "65d79495cff080e070b1d3715968fd8f2ccd06e3ad7786ec995094cba248c18c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac3f0b19f9510c8599a213401973d1cac9a0cb575bb8caa0be97d944dc94f765"
    sha256 cellar: :any_skip_relocation, catalina:       "49bc794562f3b9a0ad5799b5fcd2d63a5f866b9b6dc7a4b0d80988c388ee3726"
    sha256 cellar: :any_skip_relocation, mojave:         "e6881d8d217cebdd71e430c4ec8701d369d1ca03bb8724d30977b467d7422d83"
    sha256 cellar: :any_skip_relocation, high_sierra:    "006271b20835150dcf3006041f7053adf26a3ec58f9549029d14c844a53570c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375c8593dd6ee43951957cb526250db1e0950c29cffd23edceb0d6048d44bb80"
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
