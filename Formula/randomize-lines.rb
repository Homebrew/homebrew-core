class RandomizeLines < Formula
  desc "Reads and randomize lines from a file (or STDIN)"
  homepage "https://arthurdejong.org/rl/"
  url "https://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff6262e5a351158ca8a2b25b577a892fc4cf2b7f9a2330e9fec595970c81674d" => :catalina
    sha256 "58709789bd3fae27aaa79f0c5149fc613128bb01e50e3a5b5dbdc61fe2f1b8bf" => :mojave
    sha256 "2d539a346c5a41f2b20773d8373e61f91a5d7e5b72b6d6dde7bd7c99dae64b6e" => :high_sierra
    sha256 "19f42b1930e7a523778b18834c9615eb3c891ee490a1cb41a73f61bc47c336f6" => :sierra
    sha256 "e61c986a537a9f0c77b1382add72096e72f7447ef50ac8acc01320014681e691" => :el_capitan
    sha256 "fbffa3106ec600894f313f9770f1336227e2bf149f10c487344f26b4bf8f1093" => :yosemite
    sha256 "ec4fc7a2361d75b1b76d0b4edfdb39aae104a9c054eaae07f0b0ee55762fe485" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo", "-e", "\" ""1\n2\n4\" | \"#{bin}/rl\" -c 1"
  end
end
