class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "08ed29981e4e9ed07077139519a17273658d6097f90642a14d9dfdf07fb74ee9"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_tahoe:   "fc463b3cd1c674c21631a538ee8a4203c05a193a901c3d1df37f1d8a16ec602f"
    sha256                               arm64_sequoia: "80ef6af211355394f755ac8eed4509da7b796c1aaae345d91143fbfb8848e26d"
    sha256                               arm64_sonoma:  "f74e5ac31fc95e4024ba9a81c69ee132d99d04a76da3a399c4329c30e4ae42a9"
    sha256                               arm64_ventura: "308d7ef1bbbef4976e9099aed9221e0a5baab08be7fb0d3da25b6f0e7b5ff19e"
    sha256                               sonoma:        "ae44222b4e6352ea6d2e2d93db3d6c47b9b85f134fca64cfa849c77de18e690c"
    sha256                               ventura:       "82d872bce269b881df93402ae5a7c6bd959d0e3b7b0357109e8703f6e3a15d60"
    sha256                               arm64_linux:   "fec5451d72d8c9ba9aa4981373bb40a0e1b14ce199da29ae14f62fa7e942b24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50d7e87b82652b8b5a81852c9ef9dcc0f90daa8bab26226e702780f2a323636"
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
