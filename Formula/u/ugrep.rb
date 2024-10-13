class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "eec1ddcd17dcc017987caad916ed245adef5ccc151837eefae5f86047fae0d99"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia:  "d50bec3a11dc9ca125aaa9edafe25cff1ac7dd781f0a1a09165982d74419a524"
    sha256                               arm64_sonoma:   "747a229920f7a80acb779dbcf4baa859c32a9d6a54e0ee81da2b60cbab5ef03d"
    sha256                               arm64_ventura:  "4f080182f663401473f83a548e7f7cccfe1adc345cf7d905a681ec0ddb2de42c"
    sha256                               arm64_monterey: "293aad93929c0c3dfbe0182df593d279ff6b0da30cccad74daa266e30b468e85"
    sha256                               sonoma:         "65e17f9c311c4c71bf1c143d2fb65b4d7072b47c91da14d19929c88c1467691f"
    sha256                               ventura:        "7300be5cfa413212de3f0da14d07d3754ebfde5b6f4e96ec1934464237dc39e1"
    sha256                               monterey:       "434e1d916a8170207df99636ee288c219c5e1574cf56711b7ecefdf58b8e7828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc15cb18e70d2e344a66b59695c60cca13d6a21a1ff781512a8124cbce182a4d"
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
