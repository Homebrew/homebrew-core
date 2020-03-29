class Rnv < Formula
  desc "Implementation of Relax NG Compact Syntax validator"
  homepage "https://sourceforge.net/projects/rnv/"
  url "https://downloads.sourceforge.net/project/rnv/Sources/1.7.11/rnv-1.7.11.tar.bz2"
  sha256 "b2a1578773edd29ef7a828b3a392bbea61b4ca8013ce4efc3b5fbc18662c162e"

  bottle do
    cellar :any
    sha256 "9a780a7b9ed3b264a7d0471aba7aac503b60640af76156028ecf118a0c35665e" => :catalina
    sha256 "06a2cb705d679da7de638434f45e28764dcd448863d31f6b39ab090dfde4c04f" => :mojave
    sha256 "9bf4571824c6d8e837cfcad7ac5e16c6bfc120d4638f0428cdfb8f14203b8c41" => :high_sierra
    sha256 "8dd3263bb656dcca22605b12faf4c6f54d65e5040e58a7a464c85b69ca19dc99" => :sierra
    sha256 "1c1aa519b786f842b39720e33900e92a2f2f8deef403755e79e2d3b518897ff1" => :el_capitan
    sha256 "6d46cb2e6476e22b8bb04d00f599884aa8e44ba7e199ad860e4f15795b04e83b" => :yosemite
    sha256 "f9c4575d7384100b1cc97d9f421b5906ea5068f612c346ffa0238db6c8e855be" => :mavericks
  end

  depends_on "expat"

  conflicts_with "arx-libertatis", :because => "both install `arx` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
