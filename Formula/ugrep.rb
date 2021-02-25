class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.8.tar.gz"
  sha256 "43e644f408acf354e1a0fd963d00c06eb7f6371787b2dfd20c04a3caa576ac34"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "9d862b67e8d524d9845370a7f69937d12d805ce59ff5ddba44898acbd359ebcd"
    sha256 big_sur:       "a7875ed8d49313a8d15cf5d8900012e230a0a367b44ef38ea9e8b7fca889f1c8"
    sha256 catalina:      "cff101e82f7b6cf5c8c37dd7bd256af6126abae2b30e4d025731393bc80eb41e"
    sha256 mojave:        "20f4172a4179da7ded705ad483789831c5c4466392e35c59f3f480f2b385771a"
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
