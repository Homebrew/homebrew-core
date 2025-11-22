class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.2.2.tar.gz"
  sha256 "037468ce2cce7fa4669b00ca703fb18160a55e5440ff47fc91cb7fc10365a51d"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64f7e7abb878ff78dd5486b1484ae7165a4ffc1ce7e153e6116fac2e5f8fa423"
    sha256 cellar: :any,                 arm64_sequoia: "54546b0a148be3d339fbedaaf3c8ae110bfd94a86a6f2158c3c2f72954f3049d"
    sha256 cellar: :any,                 arm64_sonoma:  "834045201d92752ba056ca6c55cea88896b6d45d2ec409c35f6e71aee79b71e7"
    sha256 cellar: :any,                 sonoma:        "39cb1f11d23c5db8d794977f6f82fadb9ae75af52c9030bf2d310a522a605c58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1dc3a8bcb3123026f8cd8799338c0a16dee44141ddca854bbb92eb0e5bc35d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cacb8a67381565f6ab2ae3e05f5f463982e4f91c3a0ed64d25e5cfa2cfb6ae98"
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
