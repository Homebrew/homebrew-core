class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v4.2.0.tar.gz"
  sha256 "6692d4b556894d0d4539057b8e0f0c3d6273998cbd2c61e3f17e1bb22b1a475a"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "8211a7a5efa42af37129eb757132b41d4980c0ab747b3ef517acd10092e657e4"
    sha256                               arm64_ventura:  "a85d5938f6c36f68b06e41f457ba8e3d2bea4d54c7b9f69512853ff0c564c766"
    sha256                               arm64_monterey: "5800a020f5c74a2b34000b613328ea0d3ffaf12e6211a37173f1c6f442caed07"
    sha256                               arm64_big_sur:  "f4fa4ab4fc9c32056f59c929b5ab48185e3d7a659f75856c1170ff3a606d9817"
    sha256                               sonoma:         "7ca9ff8147af82ca0e3e581bb2ca1b2b4f9674f1db736814b708870f9b42aafe"
    sha256                               ventura:        "340082f9bbe172cc9b0eb82ce76c3682370b74071ed068fb63a487bbe7bcb64d"
    sha256                               monterey:       "750c52e5d97b4b95ee2ce23f89978f237f0805b18bada612787393941c21dd25"
    sha256                               big_sur:        "16ae90ba7640d0f4300630b0caa8b24f7b90c3ae47b2b365c8ccd20babf21c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763f6edc6cccd538311cf859db6503581d61e1d54c7391597edd9391d7c8e035"
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
