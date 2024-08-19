class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v6.4.1.tar.gz"
  sha256 "a90929a36c3adfbfc493cd808b0ca1e6ca0b06932447a91eaa598ad8b377bbc4"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "d1dfb2cede3769492271d6897c012cf3a64189373096369692a71077c34edab1"
    sha256                               arm64_ventura:  "5b9cb5b210b592211eb9062570407bd9ac1fc73556ea49a5388c746d605e93c2"
    sha256                               arm64_monterey: "f7e3d49b75d6e4fc57c63ae8a0bbd7a67ed1600a8ceabc0a70a0106650882044"
    sha256                               sonoma:         "b98e8dd95ad86d06ca79e3745fe0a317258ed463f5b546e0576e676c6e886f61"
    sha256                               ventura:        "3cae34256c24d538482169e833f20ccbaffcc7814f48dc3ba3c33aaf382609b7"
    sha256                               monterey:       "247ba73e4f479c14490e7db3b147e16f6b8391a9459ab50cba605fb7777bf406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9951a7d94b50619e99010444d856c0ec0698811de933ad7677a51a69ae5855be"
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
