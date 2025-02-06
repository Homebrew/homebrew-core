class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.2.2.tar.gz"
  sha256 "09aad04eb20f34ca6a9cc5626f04286b9ad722407b88581c5dabf2599a0bba93"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "5abad70dcd0bdebce9710aaf5d0f388e493cc6897254a21265a30c5bc23068c2"
    sha256                               arm64_sonoma:  "0241b06381716551d896d9ed03e22b548774a9d411ab60d85a385daf61fef9f8"
    sha256                               arm64_ventura: "cf35e6e6868494cdaca0bf8fa8520bbc01cdacce0b303e15f4b41f2c2bcbb663"
    sha256                               sonoma:        "e66b351a02448c45886d4aeddc95ce4f1cd8a73f7e05e7585193f7d1f9718685"
    sha256                               ventura:       "9da8b49f753fa67373cf80a51c8d6d5564668286c7689ffab1401cdd97026a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b4dc8990ebe413cfc1b0f6099eb1feaf2f4a329ac8a5c8c859a5cd48fe2c8a"
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
