class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.6.tar.gz"
  sha256 "4ff066c4d6afb46df598f184069eb2d96134642dca1e97f1161eebaa1d97a455"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "1994845dfe42f3a4004cda55f5e7b9c67ec8fb743916148d9b7704de0d1c32c7"
    sha256                               arm64_monterey: "f13c91a3fcecea7c329ce79c5fd9fc2cea8c7c37970dd1a10d6eb37122af71cc"
    sha256                               arm64_big_sur:  "4353fbf0b6ef6d3457db79f7a2b8c278115bf5dd2003b5fbe73bd1ed0a76a621"
    sha256                               ventura:        "92fa002fa2d2479ed88c76fc228ca6744089c8ab827397cd771c91039f4ae474"
    sha256                               monterey:       "ff8b3167c753b37d267f19ebbc858f0b1ad151c6da3a8137111d3f5b3a21d445"
    sha256                               big_sur:        "7b1f61aaba755708350cfbf79050febcf35411cffdd0216fe601def297739922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f43c98f255ad89116927762ced26afd5226d03541b9d73e4fd420bdcabd6ee35"
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
