class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.4.2.tar.gz"
  sha256 "402be01d327e4b65a0f93683bdb9859e4daa7aca29d85b00e668de4e42831c78"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "2791d1cb620949f11c33b6064f0b11b41dd5fe26eea7efdda9a8881544df59f2"
    sha256                               arm64_sonoma:  "5f88a54150fc9676867fcbdd7d41206569ba89343f2f76c829c3efeb500d9208"
    sha256                               arm64_ventura: "08c055ac976fd8abf09f49c93be3d07bdac4b152381f2a669cb747cf5a820dc4"
    sha256                               sonoma:        "c8f27c7898e900d56e35a1956ea444096c77f13667eb5b4584459a809167caa3"
    sha256                               ventura:       "d2fca52df2dfc7d3e74493574fc2f1d772002cba91a5c77f7853244833949621"
    sha256                               arm64_linux:   "b4bdb0082aac245596d58cb28e811dd6d6c6c5e887349925c1325f9d4230a753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2fc0d596da90d3214e72bd7a91bdb51612a4d208ceee5b6c4f0ab0090c94e44"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
