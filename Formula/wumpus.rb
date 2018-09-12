class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.6.tar.gz"
  sha256 "965e49b3e53f44023994b42b3aa568ad79d3a2287bb0a07460b601500c9ae16d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8e59a1fc042fdcaf087f8330b3c7083707892d8bed1f9317f5ab20777461576" => :mojave
    sha256 "5a1435e4545eea1ab436a0fba4844ac2236ea6e49e045f3b59d19adcff5de97c" => :high_sierra
    sha256 "fa693e01a17d31e9e5a5b51f27ea18b69e30f5613615c95ddb89c7dbc4bbe75d" => :sierra
    sha256 "3b6751d8a871e44c033e4a6d83009bb8b499952385d8c1743be3d26bfe37b312" => :el_capitan
    sha256 "d292048f1869507766d60e6931bffbf402f99d8fe36711ed6d9dbb060407a4a6" => :yosemite
  end

  # Patches to allow `make install` to specify a prefix; both patches
  # can be removed in the next release
  patch do
    url "https://gitlab.com/esr/wumpus/commit/ea272d4786a55dbaa493d016324b7a05b4f165b9.diff"
    sha256 "7b95a5e12447b69d0958cf00bb6413a42612ffea47cdf483c6225a1980f97fb0"
  end
  patch do
    url "https://gitlab.com/esr/wumpus/commit/99022db86e54c3338d6a670f219a0845fd531530.diff"
    sha256 "143cba3992b27addb8e25e245624902b935b29cc5465cbe947dd5ae573dafdca"
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
