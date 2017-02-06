class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.1.1/roll-2.1.1.tar.gz"
  sha256 "5d499c690d30cbe93dc571eb8e3f11d1505ce4595c8151646777548ef89a7997"

  bottle do
    cellar :any_skip_relocation
    sha256 "82bff3de41d1b0934deb3b56ef3f626307ddc11d29b335941636c6d37ace7cf5" => :sierra
    sha256 "aa97a33ccbe0b5bb53f6eb2aac100b99b3f8b79232cd058a8f0a98b78df5928d" => :el_capitan
    sha256 "96688f438082dd8e0da6f1bb4d3cdd2dab0c27ecee0b4490ccc096e958c2543b" => :yosemite
  end

  head do
    url "https://github.com/matteocorti/roll.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./regen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/roll", "1d6"
  end
end
