class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.2.1.tar.gz"
  sha256 "a377b399227296caeca3e1b8945fcfc12001e78ad735f9d3d63d8015082608ee"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "546c74a1c439123708de875c4da6ec666e3b9dbab6a7883cdfb9f531f4e12e10"
    sha256 big_sur:       "d75fb14835454d870a8dc52b51028e42d9983f887f3df0a78ba0d5a09cf9b569"
    sha256 catalina:      "fbeb23f7a09bacf3ae75faa4a0e5e77e25d5fd4b1a834128543e018cf4e26593"
    sha256 mojave:        "17f241f53694094870131b21e8a848e5ffee7231e61c533ca117146d8d5f46bc"
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
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
