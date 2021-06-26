class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://service.mathematik.uni-kl.de/ftp/pub/Math/Singular/src/4-2-0/singular-4.2.0.tar.gz"
  sha256 "5b0f6c036b4a6f58bf620204b004ec6ca3a5007acc8352fec55eade2fc9d63f6"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 arm64_big_sur: "1ba750353503ae44faf66d3bbe2a053e55435e3436d553547fc5612a7bc2cf82"
    sha256 big_sur:       "01b988c4cbe59013fbb08965a4fe6dbcd6c18f0fdf3d8d6cbb38beefde2decfc"
    sha256 catalina:      "a4ee70e0a68e0d9f7c60878584b9381717b7f433c301df26f081a2ad554ced26"
    sha256 mojave:        "df6f9254612f058a8dccc21482451b78b71792916ffed970972fb35becc05f00"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.9"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.9"].opt_bin}/python3",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
