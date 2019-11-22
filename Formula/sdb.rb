class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radare/sdb/archive/1.4.0.tar.gz"
  sha256 "958bd2283392d9dabb01e9417618d0163b76aa1a9bffd30360d97ed7e2425e0d"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "038ef6965ba8f80d1da923d7e7f19a1047091cbe50461895ab49ed6b6758a127" => :catalina
    sha256 "ce339646aae3c8ca070d2bb6d98650f58642fe33bc441f09eb041426dbf03602" => :mojave
    sha256 "6f2385c418765b70c5b10bdacad22e6dd58c8bbb773ac1ceed4295ed7927dc26" => :high_sierra
    sha256 "7d8bfa3c93e75136e19ab3dc914ff5b0906714ccc98be7f7f431ebd94e65e258" => :sierra
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
