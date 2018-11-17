class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/v1.1.1.tar.gz"
  sha256 "146f9ed6ee9d79dfd936c213e3a413a967daba3978fb1021e05a1c52c7684e9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c52c1b3615d4ae14895908b92bbe2e944ce43818813c8aabac1445062503453" => :mojave
    sha256 "32537d5e73f3c0201338362905d532887e0cf5ae4c62c263f066bf201070d0d5" => :high_sierra
    sha256 "5707d42484dfc0135f818fae404970c8b95bde7453c8f7cad91610f37d2b351d" => :sierra
    sha256 "8ca0cd759bb29d030e91a9c7b0d4043cc7a98ab7c2ffabc010f1f842d65e085b" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ttysolitaire", "-h"
  end
end
