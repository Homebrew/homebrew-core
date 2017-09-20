class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB."
  homepage "https://github.com/radare/sdb"
  head "https://github.com/radare/sdb.git"

  stable do
    url "https://github.com/radare/sdb/archive/0.12.tar.gz"
    sha256 "6f1ea21495f2df1030f56ef3517c907466eb817840d2730d4a5abb8a85096a0d"

    # Remove for > 0.12
    # Avoid "sdbtypes.h: No such file or directory"
    # Reported 12 Sep 2017 https://github.com/radare/sdb/issues/147
    patch do
      url "https://github.com/radare/sdb/commit/f824720.patch?full_index=1"
      sha256 "23ad3e130e40ca078a488103d510062fe5bcadf844e01b3ac03c0dd50133f16b"
    end
  end

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
