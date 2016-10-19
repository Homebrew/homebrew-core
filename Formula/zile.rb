class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftpmirror.gnu.org/zile/zile-2.4.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.13.tar.gz"
  sha256 "c795f369ea432219c21bf59ffc9322fd5f221217021a8fbaa6f9fed91778ac0e"

  bottle do
    sha256 "8a1abde98fa079e54148bfab7a4c0311be435d14bd96794501a5fbc6330d9906" => :sierra
    sha256 "7e9bea8f381836735410d87d0c66f879df347c895cdea89e34ead9ec09097976" => :el_capitan
    sha256 "6314085b7f33206b28706e6682f27948a1b2b516d3002fc67bcd4947576880fe" => :yosemite
  end

  # https://github.com/mistydemeo/tigerbrew/issues/215
  fails_with :gcc_4_0 do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :gcc do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :llvm do
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
