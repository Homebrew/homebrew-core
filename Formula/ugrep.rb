class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.5.tar.gz"
  sha256 "c9105eff3c22d6a39d1fcf1cf5f5185ed3f137fb36f835c7e2a7059ea4c6cbd2"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "a2dda72e239ef9c81eb86cee2134ed1ae44907007bc73fd7db924f3214fb1141"
    sha256 big_sur:       "2e04c6b33842b343733432ddefd476a471455de7feb726c954e73671b9081779"
    sha256 catalina:      "241144f04231734e8d204d97bbb56bb50f3fe303f10f90fc5d9f5fa5ad2414ae"
    sha256 mojave:        "3a6ae578c864031f0b18bcd003559e4c048e98c0372abe58f4afce5c4f915bfd"
    sha256 x86_64_linux:  "d762da41641323ca85b2c7023a8866c8792c42777d53f2b3f8767c6c325e83d6"
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
