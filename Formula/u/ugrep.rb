class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "5b80b527c3c5b4cd8f0ec300d816ac0c1dea11c6de7774d69e9becebf492274d"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "9ce6444da4fe8722ca0ef48413f6313a38ad28e71eb97a8ed0e3a4b200eeb600"
    sha256                               arm64_ventura:  "e9c3a86edc480f40c089ded4b137c70d5b8a4cb6f1ff95ed17fe4c8b89e12508"
    sha256                               arm64_monterey: "5660f233467b103b148e93165b7a6a0b12948a52ce2afd339faae8ff151346bb"
    sha256                               sonoma:         "ad482b768721f85a16d6cfc17bb6387e060bfb960b331fce18257e78c5d6e56e"
    sha256                               ventura:        "523fc74dba74a74c6c8cb70094257e3a897b13b54ed29ef63c3caea95df676fb"
    sha256                               monterey:       "6ed44233df466d576f55a5daf3536235e02c22f091c33a556f558f75d7dbf744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ba2b0babb42d1b456ddd9c3cd9e6d4983c3340427efb87ebc37528e6df76632"
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
