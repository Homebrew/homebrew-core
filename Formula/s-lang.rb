class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "https://www.jedsoft.org/slang/"
  url "https://www.jedsoft.org/releases/slang/slang-2.3.1a.tar.bz2"
  mirror "https://src.fedoraproject.org/repo/pkgs/slang/slang-2.3.1a.tar.bz2/sha512/e7236a189081ebcbaf4e7f0506671226a4d46aede8826e1a558f1a2f57bcbe3ad58eadeabe2df99cd3d8bacb4c93749996bcbce4f51d338fc9396e0f945933e7/slang-2.3.1a.tar.bz2"
  sha256 "54f0c3007fde918039c058965dffdfd6c5aec0bad0f4227192cc486021f08c36"

  bottle do
    rebuild 1
    sha256 "862f29d0ec2a550cfe2fcb3b636de4b6251be184ce468f4a42bbce03f5dfcd05" => :mojave
    sha256 "d1e3b31d585951f3b7eddd49242573ddd17b7fb15e295e3c987497fc02fbf9c2" => :high_sierra
    sha256 "587a25f8189a6579e730b9cf5bed62feb55381a66aae4d5fddfb59dfc6868802" => :sierra
    sha256 "a57f80593cc9b57b7c7eef8252a81b0240b9c421fac756010e01c5292f51bff1" => :el_capitan
  end

  depends_on "libpng"

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
