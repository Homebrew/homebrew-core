class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radare/sdb/archive/1.2.0.tar.gz"
  sha256 "7512f0e5a205937a11a5dbe0905eacb3b695c7fb71bb4b6d25b14706fa31a63f"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "12ce6b84e076371f9e21cb4e0fd30dab6eb46eb38786f394d50716cf0dfc0677" => :high_sierra
    sha256 "8217f43a1b421c477f44a532691293785b539edb39dca185a5cf058347947a22" => :sierra
    sha256 "c560a509c7bdd327bfc61e91e5d036f2d10d28b6bcccc0fca00e8eb8edd1f0f0" => :el_capitan
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
