class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radare/sdb/archive/1.4.1.tar.gz"
  sha256 "79cb0a41f7511c0568c05d889960e5ae3f00d3f2d2d72343671f95f4cf4b3bd3"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "1f661b4f93a7161a941cb3db5477d95453f7a6b789d4eb8c8d20b5a1a86b91ee" => :catalina
    sha256 "5e36426a73fca9c8b127af893a9d50bc571ecc2b4dd38517260e0555bdea49b3" => :mojave
    sha256 "aeb8d25f8c7552334e9dbb33a4bcb250b9b867fc1af0864a2e805a63b412ba8f" => :high_sierra
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
