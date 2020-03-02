class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.14.tar.gz"
  sha256 "7a78742795ca32480f2bab697fd5e328618d9997d6f417cf1b14e9da9af26b74"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "854315aad2cba51fa2b556ebce95ffb0d402a491420e900de898a22c95c082e3" => :catalina
    sha256 "812e96a8ffe6c3baaece7400306b588bfd1eb1442f943a73f34b4066ab6b0f44" => :mojave
    sha256 "d0cefa1b959efdf8344907a229bff4ea03cf9856b2d028a509e0b8e0a046a7f2" => :high_sierra
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
