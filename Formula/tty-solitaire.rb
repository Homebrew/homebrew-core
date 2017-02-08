class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/v1.0.0.tar.gz"
  sha256 "d3512beb8844ffb295cbea03bb3515fec12851bce38692e05cd55494beb2cc1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb97b8bb71cd6dd62c521fa58d8f1c977ebce6332553451cb06c724c841d35e0" => :sierra
    sha256 "eb74b5769e856283690e9b5421190146e6136c7f53368c8516dc4e5ac71e3c20" => :el_capitan
    sha256 "9c14a3abeb56ec86f4c1bb4ad4cae849f7b333a1e0eabe0dc75ac61fe0b9b755" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ttysolitaire", "-h"
  end
end
