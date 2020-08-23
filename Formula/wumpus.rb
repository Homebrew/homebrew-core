class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.7.tar.gz"
  sha256 "892678a66d6d1fe2a7ede517df2694682b882797a546ac5c0568cc60b659f702"

  bottle do
    cellar :any_skip_relocation
    sha256 "49bc794562f3b9a0ad5799b5fcd2d63a5f866b9b6dc7a4b0d80988c388ee3726" => :catalina
    sha256 "e6881d8d217cebdd71e430c4ec8701d369d1ca03bb8724d30977b467d7422d83" => :mojave
    sha256 "006271b20835150dcf3006041f7053adf26a3ec58f9549029d14c844a53570c4" => :high_sierra
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
