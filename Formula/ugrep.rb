class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.12.1.tar.gz"
  sha256 "a442ac9c0961746374d0627e6ec52d5c6250541640aeb9a698eb40382d0ec44c"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "ce33e4bc3ff9cfcc22ccecb17cebac29b6e471681c96238251e0d834f295afe3"
    sha256                               arm64_monterey: "7c1b80e7d9362132a3e52a14b702ab08807b98149c632f88ebf3ed4ebb68dedd"
    sha256                               arm64_big_sur:  "2d76e642172a16c5bcfc9e988d6e61bb2335e3fdafff40555297c1ba4e3b2b23"
    sha256                               ventura:        "93387391e35d8d9dda4971a5f550057601f4f26ea37e0f04fd09b2895bdcd2ce"
    sha256                               monterey:       "265d27cdd58b69a667faed135d4136afb81a9f65db9cf7cdd6581bea49418dec"
    sha256                               big_sur:        "797b5cb6b502e68d73f4173aa4460a2eafc9f448d15f1009c1968d881050bd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035b1545d3601262b3b17603901c00ca52e619b241dbdb083d046eb8970cf61e"
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
