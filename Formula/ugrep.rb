class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.8.1.tar.gz"
  sha256 "0d1485554a4ea2bd887c7df365f9138adf185812bd65cce1293fc6959d71767b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "6675c59b0f7e15156add8bf18e5c5ac0e4e0d5d57eef8869eafb92e23ec5af23"
    sha256 arm64_big_sur:  "17ef08d4e25005a436b8be72d88f7d01ffb5d6321c0886a6d03ddd21644933be"
    sha256 monterey:       "d16d6d89f37f472855317b447f31ed439cd723ccd8e0056d8eadc1add9d3e397"
    sha256 big_sur:        "e6a47984c27296a29ce63ad5dec798ff60e42f5d76e00b42cc3be832c0101500"
    sha256 catalina:       "d2973f47ec3c95a47ddd0d4ab5404b56d2246eae7e33e4e1e5aa31ec07fc646e"
    sha256 x86_64_linux:   "764f8c4c53ef74c41d0741e77eb22f78762dc66b7d366ced756efbb922a44de7"
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
