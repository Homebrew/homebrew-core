class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.4.2.tar.gz"
  sha256 "4b5c1c387307759aeeb76704d130a9bbe98bf68ae7bbab796efeb052e5e25e47"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4af94e6653f3b456b749f2f545ffe63e0f99553ab645cab9c5f7811fc33a74a1"
    sha256 cellar: :any,                 arm64_sequoia: "0f45bd45d169121dcf9b6749eaab1b62163fad8c44848458c125c4b551a1dc41"
    sha256 cellar: :any,                 arm64_sonoma:  "090254bae8959c6c519d3da1aed26058f594563af78560ee0bfa9ca20022a893"
    sha256 cellar: :any,                 sonoma:        "9bc15183746966b8280bfa577e6dd81e232441dc6b9c4cd22fed099686f36477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267a5a3b9a20139f936cb95a2ecb1f1a660d2d886cd7f3e45babd2120c76f96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9034e5f06a9692dbc708521e226cf319c995c0511765322c9ee600fdf86237de"
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
