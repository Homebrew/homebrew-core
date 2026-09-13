class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.5.2.tar.gz"
  sha256 "c63479a7c74aaa81b9eea44ec38e677c9e10f889c07ea3e55b5ec001b992772e"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f1f7e8d7ce2f76d03792983abed37582f08043cafefa96a25d9780fdffd1646c"
    sha256 cellar: :any, arm64_tahoe:       "2e0d7138a4348bd6efe41c4d232591cd4f35d5c31791f7af586f119b7d3106ac"
    sha256 cellar: :any, arm64_sequoia:     "2ce99368ac60b1bd25fda57d911cd3d2c73d5a435d80be5c1b001c9380238684"
    sha256 cellar: :any, arm64_sonoma:      "aa76fe581f361dc1b343a453352b3b847d7ae9d04130294b967a5ad534c03c06"
    sha256 cellar: :any, arm64_linux:       "c3795dad6e348e3d6c6a626c5ff5edd5572d0c8aef5431622c6020b8fa020c83"
    sha256 cellar: :any, x86_64_linux:      "743b341d49612901cf045ecae4e1a375718aaeef5840a94b83a75514e00e5ba4"
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
