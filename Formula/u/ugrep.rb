class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v4.0.1.tar.gz"
  sha256 "62b1c7fc9783cd73d4a6b7a2e3829683a65cdd44d53018ddc30253f404ecf54a"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "c0ccec6cbf06df2b46b2a1cbb24b74c8e00b26a39c6400acc58c4f1eb6293daa"
    sha256                               arm64_monterey: "26ce0c0df65c4eec6cadf3b8893489d85e377db98ee90564bbbce4085abc8728"
    sha256                               arm64_big_sur:  "222199fc82f5bb171a2a3b95e3845f5ebbd21e86fce4a93316077c5e665ad0e0"
    sha256                               ventura:        "9b93d0d711402eaa89ae85cff386461f74e1d8b92678ae75b733cf66535e7e6f"
    sha256                               monterey:       "283ffd99b4c1a907d6279c250a7e43e3739a9b898eba501bd82cdfc8d062e9ac"
    sha256                               big_sur:        "89f7816805eef767c02a68898df1c0b4d612e29902fa886e638b557f5a06d66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f82db5d7e7cb7d9a100c689d7c94c064d300fbf360932838302f2402f817b97d"
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
