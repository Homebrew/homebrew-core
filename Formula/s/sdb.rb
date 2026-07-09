class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.4.6.tar.gz"
  sha256 "733ce468b8e232df28dcd920ff54d137923bc83dbeda37c0f114ea85cc85f552"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbed25ed0b58334f4ebdf890dfc13446f794978938c3b4f7db0e60c08353598a"
    sha256 cellar: :any, arm64_sequoia: "0da9a18e5abd2438b00c6a655c1b2bfc2e8f99aacb9f89466101d0fbc7146041"
    sha256 cellar: :any, arm64_sonoma:  "7e6dfe3f87500436f312ae1e3f252d6939710f79df559e2fd8e551638de9847c"
    sha256 cellar: :any, sonoma:        "1b3867bb0deb02bb72b3f1f244d34101a9831b9335817f0c4bce2524cd4ea158"
    sha256 cellar: :any, arm64_linux:   "4826c7cf39a0ac2d51387bd8dbb4b987f39cd271a567a1d3cec8e5df88a57cf6"
    sha256 cellar: :any, x86_64_linux:  "2520f14db331e31812fc9e52e9ee6b0896ffb1df832e8c1440c8fcd10875321e"
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
