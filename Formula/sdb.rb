class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB."
  homepage "https://github.com/radare/sdb"
  url "http://www.radare.org/get/sdb-0.10.5.tar.gz"
  sha256 "9eae3ed9e5a889e22395333d2c3503230a6418caad3e7739b918ea37315a87bf"

  bottle do
    cellar :any
    sha256 "4fd2562bc47d9ef56a2626ed9d604e2cdebe35301527dfb7b42ae541880c3602" => :sierra
    sha256 "4db46d19a461fc1e520bda253576cb239c3211830d1dce726d2b885221c48c39" => :el_capitan
    sha256 "852756f342805573e86ca7bcf0616e403fae60860742a586ea6a792178ece176" => :yosemite
    sha256 "55ff889faef6918a5fd7c33e9a12c29367c9115889668cfd91e4e754873386af" => :mavericks
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
