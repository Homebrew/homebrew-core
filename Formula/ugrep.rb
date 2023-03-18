class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.10.1.tar.gz"
  sha256 "720b80c5aa733d906dba2caa07c50ac6242d64fde8c7402a5d69d471a94d7e76"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "5e218019d5299114b5e5f14874093dcf9bb86c973451d64c616888b516306dc3"
    sha256                               arm64_monterey: "59a13a9f2dcb4db865a9e8b5b06482660856422eb175ce49bfd6a9d86c6d91e4"
    sha256                               arm64_big_sur:  "49a7a653be03729b20942e28d31d2692e8d3dc9e69eeeb09caa333dc185ddee8"
    sha256                               ventura:        "cddbc95a2935fea8a2d2bbf0f2effe5ec7e492f1cc5d9b13e71313e2c1be3d56"
    sha256                               monterey:       "4dc83083466868c6fd9bcde218fffebf5ca368d42733774ab81ed1380341a8fd"
    sha256                               big_sur:        "ac3c8089347829698c30681f611afcc25711d10acacb769efc03d8cfaf4565f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "070e5c48f7d150db53ac04d33f395d3ac73b4234b32a3219be84c4ce14d2e745"
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
