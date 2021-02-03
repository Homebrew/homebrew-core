class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.7.tar.gz"
  sha256 "1b9fed98ea97992c98c9ca0d409da0c1f89bf54fd410ddbfdee1c57e01d4a85a"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur: "dced66b8be51ef0c4fe037f11e00ab0555f91728ac1e8a408f6f5eb2a6ebde82"
    sha256 arm64_big_sur: "922307bad1eb174cac8ab07004211d6710f2fea2cb14a7d22bbeba44873652a9"
    sha256 catalina: "ebc68d72026a6ca501226c796249f9710cd79a5bba1d44d9688c78079aca6600"
    sha256 mojave: "3fe6fef4a189655ec120d5b40ae9c1eb99697357456312cd3628fb63ffacb2f3"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match /Hello World!/, shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match /Hello World!/, shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
