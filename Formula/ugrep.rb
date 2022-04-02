class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.7.tar.gz"
  sha256 "5490d6491267bb1aaaeac27a0ba41d502f4b1c1b8998b8cc377c91374603932d"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "e2fd2403b42fedc0eb441e6f22741761acbbf4e2fcbc1cc02803fe4796650f34"
    sha256 arm64_big_sur:  "e01fce2ad333575c7ee4114067cff430044c9adf81c982dc5d677f0e1a6a6a2a"
    sha256 monterey:       "5e0f4d563c958b69b800030b2e757c98b00d1a5a303edc334fa9ae50ec7ca4ef"
    sha256 big_sur:        "0500a5076e2852e8fe129a0777d572f7d5dd43400046b68cce9ac1f1323fc748"
    sha256 catalina:       "7cf2d2681b7123f669b6d7d95bb6646bdca5a552251b46a79e02ddd809ee0208"
    sha256 x86_64_linux:   "92a1db73287553c548aeb4d406f5712b5a42983b8676c9370277c2050bb74870"
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
