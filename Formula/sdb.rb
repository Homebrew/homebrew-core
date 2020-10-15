class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.5.0.tar.gz"
  sha256 "af15354b9bc4ded881513f0f95009cc659f5d1dc4e4fa883f407729075a512ce"
  license "MIT"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
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
