class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "08ed29981e4e9ed07077139519a17273658d6097f90642a14d9dfdf07fb74ee9"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a5ea013eb5ad23c63e4fa2352db360fda62229e7d99e1aa26402e80bc9f6627f"
    sha256 arm64_sequoia: "f05163627880537dc868a8813eb512a3581c1b642caecf8d4b9f6acab2274c8d"
    sha256 arm64_sonoma:  "dfed1f44d3698dc249a1ae3fb3dbd4266edee7622a5bbe328abdfdef52cddc6f"
    sha256 sonoma:        "e6e884ba4de36690fb41d2c1db54b695e6f8c060270595d94197c361da43f61d"
    sha256 arm64_linux:   "039e903b1b53d7e0d4e3724a835ba6b27198c8a185f2cc7953e896ffc28f9ec3"
    sha256 x86_64_linux:  "5fd212bb7c62fc5974905909a95703dd803af0a4278ac101131655d016fb3a37"
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
