class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.0.0.tar.gz"
  sha256 "f575f222a3481a12f7bea36e658f699057625adf11ccae7e4a3e35697fa21582"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9981868bb8ede1a71b097e13b88494fb6fe14ddb7af40bbb04f216da63df2923"
    sha256 cellar: :any,                 arm64_ventura:  "6b02d56107712ce468480887ca94355163f3f007586c92417a712a9753db4e5e"
    sha256 cellar: :any,                 arm64_monterey: "c35442d6bc9940df3987d63ba1626284dc2feed679e8ca6c2a751d9c4295c143"
    sha256 cellar: :any,                 sonoma:         "5d1203c293a030d3508cfd64f20070a9d08ef62b70f19b0c2b386b3fe037837e"
    sha256 cellar: :any,                 ventura:        "90262454004703887c66ed062c9a6328e52f856ae2cd15ccf6991c30d4a152c1"
    sha256 cellar: :any,                 monterey:       "42aaa7e89eec926146c2f5f52f5b8db37396a12cb439ab3f790cf019c0370ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0157301844d22baceb7f3b8f6508f8dd3c9f9f72d9fa7c2c4a5255aa5c126bdb"
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
