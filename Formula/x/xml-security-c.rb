class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=santuario/c-library/xml-security-c-2.0.4.tar.bz2"
  mirror "https://archive.apache.org/dist/santuario/c-library/xml-security-c-2.0.4.tar.bz2"
  sha256 "c83ed1b7c0189cce27a49caa81986938e76807bf35597e6056259af30726beca"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ef901d1dd62aede4b0a35b64342b969c1895b519dbe5c41dd2b1a5f82d8c7dc"
    sha256 cellar: :any,                 arm64_sonoma:  "eb8d5c236aae4140590391f48ac857513958496d3e3d6e593201ef72cc321e40"
    sha256 cellar: :any,                 arm64_ventura: "ce3ae37e20ef8933d995af0447d498c1fa0f244298694e589b998467323851c2"
    sha256 cellar: :any,                 sonoma:        "9e8f17a36572dcf16e4da2ecc143a77b58647a5c15e4d7a67bd23bb1261907ed"
    sha256 cellar: :any,                 ventura:       "516a9bcaa920f654420dd343fab87694cf5902a15d17ec5cfa949c007e01b416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027db5710abf606d13b530d94cbfd9c9b0f6b619080dd2aff53fcec7a965ed9d"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xerces-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "All tests passed", pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
