class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "a8ac8dfaaf67d082d03bad58e91888256eddf5584e8ebb852b3c16591f4b6b65"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "8bdb4e73325a3e5e25e5eeab54e889c567aa50a86aecb77cd21110b720bca7a1"
    sha256                               arm64_ventura:  "0541357461d910735f884f8bdd172bbd135fea1f725622d4fa371a77e0e80ea9"
    sha256                               arm64_monterey: "d66be6bcdc5177161a271d60990e1bf49f7d2351cedca93c73ff1eacf8db5839"
    sha256                               sonoma:         "a81f24d87ac1a38c35baf8592af3e4c00b5cc49382c9ec347000c052ef6e7a3e"
    sha256                               ventura:        "26d222819aee65749f2bea53de18dc49fa111b7423dcad705212fd7fe5e22c1f"
    sha256                               monterey:       "70176be0911f2108926cd26b23577a621be0d1c435694cefe2186f01af32fd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938295378d0c3f3cb8b17b33bf445f22e0e81bbea48616291b882449e7cf6d14"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

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
