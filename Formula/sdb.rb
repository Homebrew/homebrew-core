class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radare/sdb/archive/1.1.0.tar.gz"
  sha256 "92f0acb30b58556a45629ebc76b9737dca99c9a3561c72ebc31f143aee9b5844"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "f089288c26450fa019be9d1abb789df85751f21b3cbb00cb22dcba640b48d563" => :high_sierra
    sha256 "9e92bfac5dbcf84fe5e8b3067f3b3e04fd5f0a1d5639cd1bf676425132c45152" => :sierra
    sha256 "b135f21561fedbcf92734ec7776ff5db0b00f0fd84cb7a9bcb3b9b823f6e767e" => :el_capitan
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
