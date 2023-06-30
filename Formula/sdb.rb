class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/1.9.8.tar.gz"
  sha256 "c519f10a56a0ab6a151b4e0f2f097b6c2af4709c5259463de50a94e8b7eea6a1"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2939cb0acdbf0be6a9ad82f1a5585967ead14eab2b9b0ad0fcf2b808cf84811"
    sha256 cellar: :any,                 arm64_monterey: "94907d3f9db6fee04ddbd257199239eb67c1d02f8861c644e39bb074e82ec9f6"
    sha256 cellar: :any,                 arm64_big_sur:  "07ecd9203fc1f6cd203738869734c82c5b85414347bbfff89cce08536d0b85fa"
    sha256 cellar: :any,                 ventura:        "c0cdb33f226529e86954095cc6c211a51ca55fdb5c3d4f1d1f07ad066a922263"
    sha256 cellar: :any,                 monterey:       "ea30adaba77c49d81d0d3f6f81597ee70407bd8de0ac291a33d6b9e3aeecf557"
    sha256 cellar: :any,                 big_sur:        "dbbee831f313753b1c7d4e6fa2a2a3485e59391584975d30a77094b661536aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe7f6c1e471fb4c9d1347a968912b6ef1b56c1ce56b2929121f96dc5378488f"
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
