class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.4.8.tar.gz"
  sha256 "3efa853180a9daf166c415746be0743912aa0e9e983c4ae9786d2e0372d94d0a"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c67bf3c12e9d8c67253b561932dbaa415322127d64ae933c7d31a611447af63e"
    sha256 cellar: :any, arm64_sequoia: "f611d1dc18ec3d3818525bd3300dbda2980bcd113f8b1707268a806a9a393a6f"
    sha256 cellar: :any, arm64_sonoma:  "80e1c4fada87e776ef0867d79a3d73425ccc4587c8ec3eead97332b4b0b3aba1"
    sha256 cellar: :any, sonoma:        "c61cca866dbe21b9b02d558634b6bd8618c3e5e3100b33c338d9b72027f8124b"
    sha256 cellar: :any, arm64_linux:   "a37bf03f4aa66a0d67404a72a40b61b25d50c656978e4c1e2beb390be769066d"
    sha256 cellar: :any, x86_64_linux:  "0dc44279e2bd81bbfe9cd516448af38d1109c9e8a0f2765f44d6e9973f99b62c"
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
