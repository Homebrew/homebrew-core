class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.14.tar.gz"
  sha256 "7a78742795ca32480f2bab697fd5e328618d9997d6f417cf1b14e9da9af26b74"
  revision 2

  bottle do
    sha256 "eb3ccf733c6a85290d419c7098aafd1d844880f689973276decd6bf9c19fe965" => :mojave
    sha256 "f17882759df971a7e3184638a13b889576eba380d61a005e3bbd33d3d32cc84e" => :high_sierra
    sha256 "5be3657e02aa7dca41fd0432bbff60a3d96623a89179280a31b18cbde1a6b836" => :sierra
    sha256 "25330278315a0e2fbc7cd731d69e88ba8205cd4d622ca7a0abbc638f95e6d937" => :el_capitan
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  # https://github.com/mistydemeo/tigerbrew/issues/215
  fails_with :gcc_4_0 do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :gcc do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
