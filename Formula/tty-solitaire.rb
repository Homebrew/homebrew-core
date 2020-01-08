class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/v1.1.1.tar.gz"
  sha256 "146f9ed6ee9d79dfd936c213e3a413a967daba3978fb1021e05a1c52c7684e9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3030c4238887df8b2db6125d15ecbe37dc8b14a1e45c82629eaec756b5108e8" => :catalina
    sha256 "9433dbbb39b808bfbe06f1b58b1aff782ca2bdeced389aaf0207fee720cfb0ce" => :mojave
    sha256 "6451237a79182add9dfa4678f54473adfac2a5fc47918d10eb188debcd5d9add" => :high_sierra
    sha256 "f6df872618485b7e759b8de0d3e890d1e465b0fad7e2f0373227d98ed857ebea" => :sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ttysolitaire", "-h"
  end
end
