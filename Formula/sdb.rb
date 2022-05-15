class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.8.tar.gz"
  sha256 "646add20d2fcb4beb2d5a7910368ac7c8245a63fa243ab1d3bb3732fa3a2b148"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a4065eb647b0b58d67819fc581813fef16e9b0b489c14b4bb510f65dff7e781"
    sha256 cellar: :any,                 arm64_big_sur:  "f02dabbac809bcf85a23dcd8361839643d6d79d8a2e8a716b3f014a8032b1eb8"
    sha256 cellar: :any,                 monterey:       "6160ad028353f086087c56601ff7c47a3522e8249898a4dc2869ee56ae57e667"
    sha256 cellar: :any,                 big_sur:        "f3c1f0e9f9fd6cad879a6b1c58445876400b099b6e581210d5088978a860840e"
    sha256 cellar: :any,                 catalina:       "2504b2cf1b92990e415f45154545a0a92ffdfb4df536a5ca274f22cf402123fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1633e6de9e6ef24ba56638b3207ca205c2bce652aba9d3bfe3ac456f188e9ed1"
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
