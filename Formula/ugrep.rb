class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.9.tar.gz"
  sha256 "2526605ab0490d2724a323e3e7822bf825b7181f1df815b6dbe8f0386f08e1d8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "d5385c90812d894a44c42fdaec04b8c82092cb350286cb4bea915230c9cdcddb"
    sha256 arm64_big_sur:  "f8f26c21ec1426657aa979e17e06c2cb48e99c24d1a8fa1acf6652909d946d2c"
    sha256 monterey:       "031a53dcbc5765babe25399b261057c7db3046f2229251929fce3d959b81b8a4"
    sha256 big_sur:        "44c0d50709b4471ce59b7c09c2e3382b6f812663495bfc21451229cea83cf843"
    sha256 catalina:       "2b652b54a6f73d89acb9f35198fa02c6fff4ade61acd9bbb6bcb9e2d3be44a9b"
    sha256 x86_64_linux:   "50cfc84f06777701ad8e204018d59352b9f6a7c30c2929d9c0c65b2afc4c28ff"
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
