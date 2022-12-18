class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/1.9.6.tar.gz"
  sha256 "da7ee00ed239f68dbb6a8fad165911ccbe332c6c664a5896cbd867fc9209c934"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b7c6e612fb368d7bdca0c02fb808497ec04927a016829f3687a665dfb540b2f"
    sha256 cellar: :any,                 arm64_monterey: "a875c7d8825cb1e428d4c9bc1173b597f94190b56ff73f3d09a8f5c783636a2c"
    sha256 cellar: :any,                 arm64_big_sur:  "9d1b6d126888e59757fb6b33b3d16758aef828769333b91c45236ea460a3ed0c"
    sha256 cellar: :any,                 ventura:        "530fad74fc74256e00b7a54a0794022d822171b8a3e7161897e9d042f1464a89"
    sha256 cellar: :any,                 monterey:       "73ec557ead8e379312feeb4bbd368990b435b8960d3c24c5ffb253f603ea3e3e"
    sha256 cellar: :any,                 big_sur:        "49070ca5295f26379bf12be9567c127b3f4133e4d35be393458c79bfb5096a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b912bd1552af134beca2e64bbbfad76631536bd50890d600d1f45763ddf117"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  # patch build to fix version.h not found
  # remove in next release
  patch do
    url "https://github.com/radareorg/sdb/commit/3bc55289a73bddbd63a11d993c949f57e8a7f7cc.patch?full_index=1"
    sha256 "d272212a0308a4e8f45f1413c67fb027409d885f3e97166e1a896c7d6b772c4b"
  end

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
