class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "http://www.jedsoft.org/slang/"
  url "http://www.jedsoft.org/releases/slang/slang-2.3.1a.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.3.1a.tar.bz2/sha512/e7236a189081ebcbaf4e7f0506671226a4d46aede8826e1a558f1a2f57bcbe3ad58eadeabe2df99cd3d8bacb4c93749996bcbce4f51d338fc9396e0f945933e7/slang-2.3.1a.tar.bz2"
  sha256 "54f0c3007fde918039c058965dffdfd6c5aec0bad0f4227192cc486021f08c36"

  bottle do
    sha256 "e1aaf2f64bedf51fcab50c24cac9a85f25e5c53b78d3b3df00ff13d93dc3b1f5" => :sierra
    sha256 "f6836798d838e52af2536255ed91b96e05068b7378fb93b4bd0fbfd52e04a381" => :el_capitan
    sha256 "52fba342bc32cf218d575154b655a95bcd0e3e1dc1e1ea8e98e78455abf1ec68" => :yosemite
    sha256 "bc5d35bdfbfa639e3b6403b25a36a49c1dca66cd85ad25adedcc9b67db9873e2" => :mavericks
    sha256 "751b0127d64c72f502a2c197c625d0a505325c993fb39d1bf6dbdc4f9bb515c8" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "pcre" => :optional
  depends_on "oniguruma" => :optional

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
