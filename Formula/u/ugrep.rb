class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "128eb172399444689725e96626598bc913a880609a51e954646f91219ca1f519"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "20e44018918848f2f70e518fc8cf3e5fe9d5fed7f21af7e26b24efe034ad3b31"
    sha256 arm64_sequoia: "0a1c323b363064f7692602f51307801661b00f50939a84094b811a1f3b577d7b"
    sha256 arm64_sonoma:  "26068ee81851cce2494204c0b54dde9dd491da7807e0047254a5507dce6f2b4c"
    sha256 sonoma:        "4f4a5cf5b36c84c358b2fd7b8c8c9c680d6ecf4bcf329ed77437d6bc77cbd2ac"
    sha256 arm64_linux:   "a44a3168e55a865e58abea6d88e496bc23150bdb4f9df23cae9acc5140bb17ad"
    sha256 x86_64_linux:  "4fbc8148f6884800aaea2ffe81342309d87dfde0a1a5278d3c7452795dd03a2c"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
