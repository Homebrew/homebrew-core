class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.2.0.tar.gz"
  sha256 "05b6fda41727e2d634bc0cdea0bccdc186b48cc9136b2367ab2a7358145fa8b4"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e5ea5126ab9314436e85c93b9280c5498950b499cc18a7c25e509081905988c"
    sha256 cellar: :any,                 arm64_sequoia: "41695d0cc3526175b99ce5850cd4246af15e374e32b30bb20d5fee4a534fe1de"
    sha256 cellar: :any,                 arm64_sonoma:  "6391d94f5571c5c19fd0865bb3bc6793bb9596fc2a49a5af39e1910712899858"
    sha256 cellar: :any,                 arm64_ventura: "63004949cd084e74ced59cb3ce84fe63bc7095da5602f01e58a5d1b0026b2b84"
    sha256 cellar: :any,                 sonoma:        "3b8395df7ab426e250cc8e26a1b06e8699d78724f8becacdad1f14881336c784"
    sha256 cellar: :any,                 ventura:       "77e283d412b4183d9d842562b617e7598113e9e2a9f3f40acc4ca2876355776a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f729bde1f426097c7d2cea72103b12bf8ef0874f4b62ae0f2ed3ee04431a366d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47575b7d7a3b8e9e40369e40f783370d8ce9f91394b5f6ead66d1bab140b0fbc"
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
