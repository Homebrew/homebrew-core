class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftpmirror.gnu.org/zile/zile-2.4.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.11.tar.gz"
  sha256 "1fd27bbddc61491b1fbb29a345d0d344734aa9e80cfa07b02892eedf831fa9cc"

  bottle do
    rebuild 1
    sha256 "0d0ee62df1d61c04c6b9dd73e16b07aa9d170857716614326693c460377b09a8" => :sierra
    sha256 "bedcc322bf58b7699ff03d88b6d203e493ed30fd14ac9309ed4e4d0c7416cedc" => :el_capitan
    sha256 "94b919340c46ed2f2be1604fc955c519818e2424927b12d8f13bb8a8140fd8af" => :yosemite
    sha256 "8230e74d3104b830c1b100dd5050f548b79dc3a51631349293812826a047d14b" => :mavericks
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
