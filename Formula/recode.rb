class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.12/recode-3.7.12.tar.gz"
  sha256 "4db1c9076f04dbaa159726f5000847e5e5a83aec8e5c64f8ca04383f6cda12d5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "946547cc6a852689c9aec88304c31cc4ccefccc445e8c354f02a3d3f307e1848"
    sha256 cellar: :any,                 arm64_big_sur:  "cfe0d3f306397fcb30ef57b6a10e9efaad602353d63015641c70543f9760e353"
    sha256 cellar: :any,                 monterey:       "ad198e3f6095736d136841e530a7b447e5539668999f683f2b9f5ae0f6d11914"
    sha256 cellar: :any,                 big_sur:        "29a770e70ea05708f39e3fd296eb30305d79b81352967f18f199f2cc6ea7dab5"
    sha256 cellar: :any,                 catalina:       "26d4cbd59af48f7da47aee5a910f3ec9f7a090a3f01a3338df60ac267472042c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6ab05069d3a56be1bc774bc82795c1f47acb7feba6489bfdee240dcd1bb5fb6"
  end

  depends_on "libtool" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
