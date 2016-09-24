class Sic < Formula
  desc "Minimal multiplexing IRC client"
  homepage "http://tools.suckless.org/sic"
  url "http://dl.suckless.org/tools/sic-1.2.tar.gz"
  sha256 "ac07f905995e13ba2c43912d7a035fbbe78a628d7ba1c256f4ca1372fb565185"

  head "http://git.suckless.org/sic", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "efeb0f7a31a6d4f0ac4c065a4646b5a523788b5edbddd9f99ffa04f00aa41f97" => :el_capitan
    sha256 "99c98bba7ce3793f8f5431cdaee24a0bead3a1a2335bce10dc9cf6d53213c249" => :yosemite
    sha256 "23bfa1932017f0c189e6e3ab1345260d8b5a98697999d6548b9046e7662112db" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
