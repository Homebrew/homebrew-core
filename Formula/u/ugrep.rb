class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "e134f5080412dec8023ca8d10433c4860e95557c1ac05140285a203b06ebab61"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "8bd56e07f24f27dfc9d3ab88a36d9c448cd9a4c248b91502faded1f500b1dfd2"
    sha256                               arm64_ventura:  "bfeea2840f8196be3b57a5ae962ed1212a2443416981df526221827d07187c4f"
    sha256                               arm64_monterey: "5b91cb20a1d16200ba48f8f6146fb5396669d9e997d46f8ea98172cc94319f01"
    sha256                               sonoma:         "4f809594a33f006ed92ef1d92ff0ae4259248fde8574b3171410dff018edd029"
    sha256                               ventura:        "7da551885a5f1401a677eae688b717f2a7a89734ad2d14a875f95ca9caa0cdab"
    sha256                               monterey:       "43baf0cc8dd4c135bfcc60d76618de203980bd0a246527b1332ae4d18ae39e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8818df971b8dfdd7a7e312a039de074667fff93ed00a09ad3669854beaab1578"
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
