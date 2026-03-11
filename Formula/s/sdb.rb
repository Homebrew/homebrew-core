class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.4.0.tar.gz"
  sha256 "9bc71849f82857c2b922041aa534aeb326d08df1064489a0cf06aa4ec6e894c8"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a240de3672649f6c72b00364523fd62ad43b58975c411f6ed49540c21a28dbf1"
    sha256 cellar: :any,                 arm64_sequoia: "819cd41698fe626bb8f055a17937e6ec35905bf91ffb8d01fc38b6c4c63ab5c9"
    sha256 cellar: :any,                 arm64_sonoma:  "68bfac9a8bf93b639305e0227b5d2742caceb6034482c60cd949a557847b0c54"
    sha256 cellar: :any,                 sonoma:        "05fc0c0772d4f58d613f83067567f8fb222411339b8c64cb13845b4eef6161ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b64248b444d2695c607f055b1a8b0359643569a1d3ccd2ce2eadf6b49b34777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94cfe4fa5c817b21a2bc4e0ce8e8634471b6149fd1a5f4bdd2569a87eb0efa13"
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
