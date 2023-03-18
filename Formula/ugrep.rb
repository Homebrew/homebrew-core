class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.10.1.tar.gz"
  sha256 "720b80c5aa733d906dba2caa07c50ac6242d64fde8c7402a5d69d471a94d7e76"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "5aa449edd13805c47a052a9705a0a4e244d48bedb04ef749540ca9e74c2156bf"
    sha256                               arm64_monterey: "70072a8b5e665c50332a8ac6815df4521134da7acb8aacaa940c12d4d89b322b"
    sha256                               arm64_big_sur:  "50a651de6cd3c1bf5e0e921f75be0fae1bd5fb3c7c74119991878fe9fe8d9fc1"
    sha256                               ventura:        "ace1c4cc087616df6e25b8fbfb49f9f830b0cc820b5ee4ea3b49e03a7dd1d162"
    sha256                               monterey:       "7154d3f7d24b119c49679a98d9dcee9d6f32ed61992fe7bb7c2d03c59020d23a"
    sha256                               big_sur:        "6ff4014dfa583de6a108bded85976f0adb79f353ac6962f7a28187fc90a6cfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31fde7dfad737eecc8b5c1313cb07dd1142e37c1eef17ebc54bf07f74ca8b973"
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
