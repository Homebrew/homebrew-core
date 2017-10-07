class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.14.tar.gz"
  sha256 "7a78742795ca32480f2bab697fd5e328618d9997d6f417cf1b14e9da9af26b74"

  bottle do
    sha256 "29bd460d08eeb0f7ad14372d47ad7c4d4fe6b8a79393eddbdcf1e60b69225a37" => :high_sierra
    sha256 "49034f6c2d94b5035fdb13855347d855f18c02149948638215e21f3f42e7edfc" => :sierra
    sha256 "a02381458e1aecc2475c3845de501a455664eac121677fafd5e92a818068e614" => :el_capitan
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
