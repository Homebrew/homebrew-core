class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.11.tar.gz"
  sha256 "47cf3eee0a6eb759a5ee53b8e0e09d5d1843c5597cfd83e9c88f1b29e6873b2b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "ba5bb99587a9fc28a7119496a35e18309389a990fd39c708799e2a742a559cd4"
    sha256 arm64_big_sur:  "7e41e3c5fcd51499133969e4796487a67a2b9aae3f5ef10f17e0a0eab54d6ab1"
    sha256 monterey:       "85eed6af37624432b32e1e329bf44862f946a6b873c4ec886e63af01369336a2"
    sha256 big_sur:        "9b9b863cfec5f0fb5ed675b3578b18eae728b72754f27866f83ca03bbfd56c90"
    sha256 catalina:       "895e41809a8d8766a4b1aad7e30d86872d9350d72d9af3feae61d2524dcb7d73"
    sha256 x86_64_linux:   "72588c26c6978fd659e711f06f6f3846bf83431eb4efe1e212fb9b2f940df23b"
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
