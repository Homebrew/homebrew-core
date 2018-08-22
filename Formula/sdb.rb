class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radare/sdb/archive/1.2.0.tar.gz"
  sha256 "7512f0e5a205937a11a5dbe0905eacb3b695c7fb71bb4b6d25b14706fa31a63f"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "a6caf79bd15c99569d32143d4a59cd5adcd50f3e3170efba3d888adbe43f9c4f" => :mojave
    sha256 "a1ba1c72420ea9b0c62ea79f8b9f23ac5e20c4459c06823543a62d2987993ffc" => :high_sierra
    sha256 "4847331fb2ef7220e9d1a565fac151b126419a9aaac48d46e361a40caf5b6f63" => :sierra
    sha256 "37397845ba68e2afcda98fdc5ecbfe652bece2b3943dd36510a10e3630ac6520" => :el_capitan
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
