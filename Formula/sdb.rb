class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.6.0.tar.gz"
  sha256 "af9ebda0b9ab0c61dba992d9fa3bbcb5c30ad8ec812b0ffa441e608117339916"
  license "MIT"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "95163d62cbd702fabddba0dd1bde7213254e35a54181874308c9778f51dfcdd2" => :big_sur
    sha256 "a41f0dfc6fe035b7206c543c92a2bc95889c444914cf4fe404f8c88b0a855201" => :arm64_big_sur
    sha256 "04aa601e84f7f4d95e17ca2675564d4d3027e9736e57d4db85461c7a843ea025" => :catalina
    sha256 "8b110c8f73ccbae52f0e600fb3b67bef8088c541710fbe690b0548e4c2f09703" => :mojave
    sha256 "baa2ae3e71b94ba5241956188b631ece503344129f41a407268bafd82a9b009d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
