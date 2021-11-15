class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.3.tar.gz"
  sha256 "64ce15213f8c7cc88ddf5f64f893c47dcae398a197f21bba885595fe8db1009b"
  license "MIT"
  head "https://github.com/radare/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "47ba447117de5045231e485b097916942fad64b1ae7e88e64f02100e28104699"
    sha256 cellar: :any,                 big_sur:       "e6a3c1aeaddcc7558f3c7e1263bf0ae4b336ab1ec2803c0611fdd88a91d5cf5a"
    sha256 cellar: :any,                 catalina:      "3b83ffab7521c5de9794862e6b024412aba61ea62f82ac77b3f9e3c389072f4c"
    sha256 cellar: :any,                 mojave:        "a9e8d136fcb35dcad3b24c3435bd9709c885dd943329c0ec8a820fca364df159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de64cba3235caff388c3667dcc42e5a321077179bd21750a7eb497fd7ba69fe"
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
