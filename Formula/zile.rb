class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.13.tar.gz"
  sha256 "c795f369ea432219c21bf59ffc9322fd5f221217021a8fbaa6f9fed91778ac0e"

  bottle do
    sha256 "f7dc25c97ab09bcccf37413dc7014e0a3204384574b02ffdb99cf2b418edd691" => :sierra
    sha256 "cab5ad88b8f8a1a00b82516100a86bd3e60edf3e06971d283fa6b2454197adad" => :el_capitan
    sha256 "42f3ec505b358369d9c6058602605ef4da80266813ce577916673264a7a608b5" => :yosemite
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
