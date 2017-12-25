class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.14.tar.gz"
  sha256 "7a78742795ca32480f2bab697fd5e328618d9997d6f417cf1b14e9da9af26b74"
  revision 1

  bottle do
    sha256 "4d1d81f3d9b08e43cfa4ea8aa2e6fd16b8529f6d97876d3456c4682e625ca0f5" => :high_sierra
    sha256 "0fa34a0d34ca7b3158dd7368f8f225709a282e2f574380f3d0e5f2872a1923fc" => :sierra
    sha256 "3ce1299d9c4f58bda18ddfc62d8af3b48843355bb9ff0cc2b13830f84a5fe08c" => :el_capitan
  end

  # https://github.com/mistydemeo/tigerbrew/issues/215
  fails_with :gcc_4_0 do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :gcc do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
