class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.5.8.tar.gz"
  sha256 "34f31a0fc99cc8d84390f8a46a0e12a77acccbfe3d7f1581293f7362dbd8db6d"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1de4bf2908a108ddda9d74a2c5dc2865b30e575c2b1ca531cb301d3bbe709027"
    sha256 cellar: :any, arm64_tahoe:       "e935f6c574b3b1074923389ed5d80255db150f3cd9edd95499b5c02bb501f217"
    sha256 cellar: :any, arm64_sequoia:     "8f4dfa18820e5e58fd3d0125f472ae66af3684dcf5569ec3ffe4ea624f58a256"
    sha256 cellar: :any, arm64_linux:       "0a473e7892bfc752bc3f7b2b6b8dfeb1ae36ce87d0518d2ba6aab8236626379d"
    sha256 cellar: :any, x86_64_linux:      "f651f26b76293890570d06a5016e130c152fd27c8aff5439fe4f60da6d91bd2e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  deny_network_access!

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
