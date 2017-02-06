class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/v1.0.0.tar.gz"
  sha256 "d3512beb8844ffb295cbea03bb3515fec12851bce38692e05cd55494beb2cc1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e5603d7db19e7888d296b9324080d89855b6e96f5d47a6d2378861d43c7db25" => :sierra
    sha256 "3778efc923649dbfaab098cbc01c5b0c87477f01506e59cac77b684e60da05cd" => :el_capitan
    sha256 "2570d62a429bcb4e987c91f1c320a2b138964d24ac37ee50c0602d77158f23bf" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ttysolitaire", "-h"
  end
end
