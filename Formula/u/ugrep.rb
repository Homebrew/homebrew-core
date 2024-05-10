class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "ee155c8561747b1f694e1cf4a064c2e4d504094d0714e908e3f9ea2ac9b7a9aa"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "3af584b15f7464be0be08f71159fc52e8535b7325a537bce2b2aeb4159abe6bd"
    sha256                               arm64_ventura:  "42840446ccc96373e95861631093894b8d6f36136bf89a4306a97fc42f28b392"
    sha256                               arm64_monterey: "2198e4b341a477f154f24f41e1e299930532d6b415403ebb2aafe5beb3e94e70"
    sha256                               sonoma:         "ae36abc156834815e85d31e5ffc9bfebb7cba86b6ec380cda0f0b5b84b84cc03"
    sha256                               ventura:        "ac71ccc3c26d2b23c37ea27b9f00e2afa0cf16b056d9d044b0513bf35b3d68ed"
    sha256                               monterey:       "d70d87f3d06e60ed7d3e21024e627bb16d0df97c3667b2107fac95275d282bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e25fb8a93b4457a306b7cf2d5fc03e4d3c09d06b5b8a2c6f0e379384c5c153c1"
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
