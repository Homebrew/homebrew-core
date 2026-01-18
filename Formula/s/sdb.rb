class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.3.2.tar.gz"
  sha256 "28cf10b3788b0cbdb46ec46b91ecca68091e88bb00fd1e6ce5f02a5c09ab4d67"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "467d31f7b247f5bddad146f14eed4ff027e335f59e9b8c4a60eccc7bd1832de0"
    sha256 cellar: :any,                 arm64_sequoia: "3664a76db0ab03f761d22993ef8b1cc063a4d48264a39707f9e8b73e38b034c1"
    sha256 cellar: :any,                 arm64_sonoma:  "d1c010b22dc2728b8c3167fedfb4be5913ba195b756a77440d8d609bacadc197"
    sha256 cellar: :any,                 sonoma:        "1dc6ad237420827ff60f0537ef3d8bedb6e066f3cb0d45d0379221a0a1b24906"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15708011035533daf3baa9af331e7c5021f113cf62d9ca4fe61f5559418fce6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a40ec6519e75e6ebb1cb1b69c2d94e7f9a515a14ea338966c1235b23fe81e7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
