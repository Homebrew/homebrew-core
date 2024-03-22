class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/refs/tags/1.9.8.tar.gz"
  sha256 "c519f10a56a0ab6a151b4e0f2f097b6c2af4709c5259463de50a94e8b7eea6a1"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46b13d892361f3f266dcc879f3b1356b80411d22e255be8d8be8b25dc110da2c"
    sha256 cellar: :any,                 arm64_ventura:  "d26fdbe65f6fb61bae60ceeec8702602cfac3cb80551e2409eaad63a1baf5c40"
    sha256 cellar: :any,                 arm64_monterey: "d9cc13db6eb2ed5ed2bb1c0e15fdc16c073ab7d3035e627159d5b848845116bf"
    sha256 cellar: :any,                 sonoma:         "6cc22ba3df57f2b7370402324898032c9fa6055fe21947bb6c3beaa570ca5afd"
    sha256 cellar: :any,                 ventura:        "b163afa2f7945d652f0a4ae77fb4c1cfaa46bfad8b71e9f27b7f1718d19c7dd0"
    sha256 cellar: :any,                 monterey:       "d072e4bc318c08ee307a1740db311273e9ccc468076bd5217c91ada01c7a0fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f55490faa3255e320eefbcdbe11a9000db050dd2ccc26a42c35117a6e085045"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
