class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.6.0.tar.gz"
  sha256 "af9ebda0b9ab0c61dba992d9fa3bbcb5c30ad8ec812b0ffa441e608117339916"
  license "MIT"
  head "https://github.com/radare/sdb.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5052052465c70657aaa11553748cff312e713ab0731ebbe7912de36a55d94f59"
    sha256 cellar: :any, big_sur:       "610fa3110bb3625590bc8a3a931e68ead2ea2a6ff58badfd5bc2ad8f8b229088"
    sha256 cellar: :any, catalina:      "c99fda005b37af0cae08040da70bfb9868d600197fc306953b64f0dac9311c0a"
    sha256 cellar: :any, mojave:        "cd34be961f33a8c5f617f37da20280b73906e57542c6e9764ff5d984936d40e0"
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
