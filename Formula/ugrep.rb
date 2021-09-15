class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.7.tar.gz"
  sha256 "6125c19e33037714645a8d5a8700659d02e46a20c8e1f62c0a766d2a9bf0f93c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "ea777d7f36f2997b0383c9952b214d04d7c13c5049cd3219f687a5a05725cd0d"
    sha256 big_sur:       "66a476a8282934de9ad515706a3fded9fe02c938d5d153c18555b88221c0ae5a"
    sha256 catalina:      "3036169564aaddd819fcb8bd59e09322dcc5bcfd4789e1a20997650b0f958492"
    sha256 mojave:        "30c75cc2629655f9ab7fb25dcb1a72d178578c875ca60bf9cfeb3adad58b6ae6"
    sha256 x86_64_linux:  "ee64159d4324d9de12acbca2476f0e1322ca7e95faa5fd2f5514dd2acb19fbae"
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
