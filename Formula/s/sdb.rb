class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.3.4.tar.gz"
  sha256 "2ddaaaf5cef6476b0e3eb8ad54ded9f0de3fac2dc2df5311a95e2905cd7a2df7"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1a4dd3159fac8732d6b7b5cd11d04048e2b181a4798b6f8ad0baf1ae0efa2e0"
    sha256 cellar: :any,                 arm64_sequoia: "3ffa8b0e0c82522652e82534120723774bc20ecca6bd1e20556cc7c924d6cdce"
    sha256 cellar: :any,                 arm64_sonoma:  "9a7918e96e3537de74254a8aaaaa2493c6526e3980bfd3ea120ffeb4fa03db0f"
    sha256 cellar: :any,                 sonoma:        "679a835d8c2dbf05b71b44157a948eb3ea3bf2f4a6da503126ed5d17511d272f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a847c514b996a6e73fd594567e66169bd63b1ad8d38d050e50616235ba55e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1302c9024fb30296ed0656328aa73fa2937279e452d5c2f0256f6ea0bf4eb455"
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
