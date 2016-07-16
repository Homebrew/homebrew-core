class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB."
  homepage "https://github.com/radare/sdb"
  url "http://www.radare.org/get/sdb-0.10.4.tar.gz"
  sha256 "124e9ca05308100876bd1faf3f71c062be1236846600729d4aa9029f41a08a11"

  bottle do
    cellar :any
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
