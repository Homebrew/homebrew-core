class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "a8ac8dfaaf67d082d03bad58e91888256eddf5584e8ebb852b3c16591f4b6b65"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "17fba0c68b865a5eaac1fccf428929c47726e2ca5597ba34ef56bc230c11e1ce"
    sha256                               arm64_ventura:  "13fe29a98c268b12eaa89d373453b5f708a9683942ab13acaebdb6060ce58c20"
    sha256                               arm64_monterey: "199448c15548e52c1fafa3455cdbae5d45874d8a235d864dac990dea3a104b3c"
    sha256                               sonoma:         "1915c640589680927c92ea332fd9fd5a68c62dcb98935a4737ab7286730f665a"
    sha256                               ventura:        "1ccc1574bf597f980c3477d94c41dd4659aac328add36ab0a6c968c970511c64"
    sha256                               monterey:       "c0f939fc01c38d7fe1a661366864efa731863094c8159a3c15d28f28147f0cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8651ecbcfb1ceb87ee5b45d02c0a837dbdde2534f41dd53288de93bcccd7c3f1"
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
