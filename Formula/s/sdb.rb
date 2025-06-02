class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.1.0.tar.gz"
  sha256 "877f1540f8890ee32ddfe5a03c3455d7d9bf344bc55a6ac42bdcc7ba241e8ab9"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe7fce5a05792a0d970268a111172ff4a92abd948f98499b7b48304e7c17fba0"
    sha256 cellar: :any,                 arm64_sonoma:  "460a6293a18f7925c2794221c34781a085e279e7d73b1ed54b531e35771456f4"
    sha256 cellar: :any,                 arm64_ventura: "a32fdde7aebe6d674e9427d2de15766a28f30c741b96e14dd2c3b0cc241ce8cb"
    sha256 cellar: :any,                 sonoma:        "6c66504eaf55a72603ed5b724b06927f1aac64a9a5b3bd1e80205c8ae8a20c38"
    sha256 cellar: :any,                 ventura:       "85295727af6d4942c6a2c1f9611d5c22437da0d9a72155b4803a68e3d49433ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "733389a09b477680c399818f04dace96ab23fdfeade9296e3f4f8a96eabf4d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224892c60361f6e6bfecca83ae56e73648bd7f3a439880e9403e2b3dbbc3750d"
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
