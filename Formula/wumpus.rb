class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.7.tar.gz"
  sha256 "892678a66d6d1fe2a7ede517df2694682b882797a546ac5c0568cc60b659f702"

  bottle do
    cellar :any_skip_relocation
    sha256 "f99f53b1d8ec9474947be066a7338daf6e8a20409137b7114358dcb3dfe388f0" => :catalina
    sha256 "e8e59a1fc042fdcaf087f8330b3c7083707892d8bed1f9317f5ab20777461576" => :mojave
    sha256 "5a1435e4545eea1ab436a0fba4844ac2236ea6e49e045f3b59d19adcff5de97c" => :high_sierra
    sha256 "fa693e01a17d31e9e5a5b51f27ea18b69e30f5613615c95ddb89c7dbc4bbe75d" => :sierra
    sha256 "3b6751d8a871e44c033e4a6d83009bb8b499952385d8c1743be3d26bfe37b312" => :el_capitan
    sha256 "d292048f1869507766d60e6931bffbf402f99d8fe36711ed6d9dbb060407a4a6" => :yosemite
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
