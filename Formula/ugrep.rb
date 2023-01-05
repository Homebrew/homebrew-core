class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.4.tar.gz"
  sha256 "4e2fed4b347a0cd84709dc6629f77cab4e389337b015346ca250b1bc95689382"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "d7adac1572381e25bd3a120e70bdea33d9322f141f23e44aa70cdd01bf44686e"
    sha256                               arm64_monterey: "171adcea631cd7225d75d2fff7dcbf09e4361170787413cf1b5a4b58b23dcf65"
    sha256                               arm64_big_sur:  "3ccfad955e934e0fb0661ab45b89cd85dca859a87b064daf8c267a3716c87a19"
    sha256                               ventura:        "2397331a26be262186f3d6c2773951e0aca35a6039af23b07cd7daa6c3e45ed5"
    sha256                               monterey:       "b46b4c59d7a66a9f48e6ea14fa5c76127dc5b7dbc1341ef7ee38df4fbcad2406"
    sha256                               big_sur:        "26051bc9cd3994f869891226f7f9d901a246a3bc43e135de74273ed94dd6208b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28fc1fc5a5ddf69365061cea0a8c646a58796fb5ff2cf8e5258418ff6366f5c1"
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
