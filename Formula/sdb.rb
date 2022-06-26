class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/1.9.0.tar.gz"
  sha256 "29c2dede43ad4eeecb330e0b0c6fbb332d8a72f7b183a9d946ed2603e0ae3720"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c739b1aeabeca4a0e049b9b58c363795f64e0651d8818ad153ef194f91b59cd9"
    sha256 cellar: :any,                 arm64_big_sur:  "d8992da63dedeb5d340ee3711205f0301c0b7b4914759817370da4aea1d4c04a"
    sha256 cellar: :any,                 monterey:       "91da7b11e0fba02df72bc17219f27ef6edd68155a23febaa2b7738df21f7c5cb"
    sha256 cellar: :any,                 big_sur:        "9ca357d124dfcdc4af70afcea661c0bd1b75577743a0e42c7c42e008dd013411"
    sha256 cellar: :any,                 catalina:       "683ee06ffd042a64f8c109318465cf9402ad351cc8d5a282b7318005e2d59f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35a3b67f282789c0ca1f18be9c44b47bb9d73d855df2dc12fd1b41a8e96cfb4d"
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
