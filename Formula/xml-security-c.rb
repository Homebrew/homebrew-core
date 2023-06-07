class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=santuario/c-library/xml-security-c-2.0.4.tar.bz2"
  mirror "https://archive.apache.org/dist/santuario/c-library/xml-security-c-2.0.4.tar.bz2"
  sha256 "c83ed1b7c0189cce27a49caa81986938e76807bf35597e6056259af30726beca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "44e619c0775264474da5fac0a3b7a76c169b9440654e8ce206f77e4a89e22d41"
    sha256 cellar: :any,                 arm64_monterey: "8c02de297010d750925ab642739e56c514af13100a6d4893923ea074e389a876"
    sha256 cellar: :any,                 arm64_big_sur:  "f9006574dd2cf981840b09296014164bda200753726c46f946483dacbb015042"
    sha256 cellar: :any,                 ventura:        "1b7278375b07bc250e636698e4acbb2bf49011b49886f87afb41cfa38e253029"
    sha256 cellar: :any,                 monterey:       "74905e5b09e2f9c88206c2d4a967018e9424a54cd67e7734f7d87f385e1477eb"
    sha256 cellar: :any,                 big_sur:        "53f03034f650807fa91a96153c82854582aef1eef8caeab601703c46d354a752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c52a6310c4a117dbde92b4486d20434b644524daf533a259697ee125bd8bad"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "xerces-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "All tests passed", pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
