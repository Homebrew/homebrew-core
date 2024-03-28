class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "687fc43a02287bac18f973822036bb3c470a81825b8eb3d98a335603b249b13b"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "aa36c884f8ad1e80e367de87cdf3fe26f736d89b98d3e8d90ce6ee05f3cb5d51"
    sha256                               arm64_ventura:  "a02eac473534f8ee1278dcbf728ac3511a084c07773102496540b1c4e64a6a03"
    sha256                               arm64_monterey: "7c52824ce422c0844522fc398e77ebe704fd31474e3759e9457b05a5f9acb226"
    sha256                               sonoma:         "9dbb1b2709681fe2392c92d4bc27dc0183e76cab720aba1e9d877a54fe6393f5"
    sha256                               ventura:        "d72accbd93df1febf3388ef632daa6c42763fcf45846523cf2873ff9f3ca4f12"
    sha256                               monterey:       "5b16d6a03c058430db85bfcb8b15f2842cf3b28c9987a8511235fbae6174933c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67e438e1832c5af6a4bba00a9ae66b7d346f247a89339daf9c4205a8ad751d4a"
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
