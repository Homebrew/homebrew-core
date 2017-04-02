class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "http://www.gcd.org/sengoku/stone/"
  url "http://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz"
  sha256 "b2b664ee6771847672e078e7870e56b886be70d9ff3d7b20d0b3d26ee950c670"

  bottle do
    cellar :any_skip_relocation
    sha256 "540bd64b2264bfe03d88ad620a7138a1d96742d6810eec301fd7e5ea63970ee9" => :sierra
    sha256 "9d4038c7882d2fe256d77340b5e0ec52a551697b9869fb61f3a22b0be917e92b" => :el_capitan
    sha256 "e01e391d43da23b477186a54f96b0d20bb67c24e1503e20408dc12d025f04def" => :yosemite
    sha256 "ab43aca5038bdf014c1a5aaadb9e526626c9c4369dcaeac045b9dce6514b30bc" => :mavericks
  end

  option "with-ssl", "SSL support"

  def install
    target = (build.with? "ssl") ? "macosx-ssl" : "macosx"
    system "make", target
    bin.install "stone"
  end
end
