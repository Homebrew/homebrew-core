class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.5.0.tar.gz"
  sha256 "d77c1fc1ba4474c01d6c68ed45a06829ab7559c5b0af0b0f659a2a990d633263"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b5aac5a10a4262a8cb5758c10e6f51e750f5c2fd84bca64a72026d89c3584eb2"
    sha256 cellar: :any, arm64_sequoia: "b87ec67587b023a077e9ddc7e8e6d23728b22c366a80cc2c16760051bf52330c"
    sha256 cellar: :any, arm64_sonoma:  "8d0cf5369ef85402fdb5b834ed188606889e9f1915c58443fd8fbc6e1c2c1bda"
    sha256 cellar: :any, sonoma:        "24c829730cdf93ef493113dec7e83df1a3b6f2a7add304018f7d3552e7b26e2e"
    sha256 cellar: :any, arm64_linux:   "9ff5777529ecbed92924b21bf00b2009e35acdff473e78bfe8a3346a8e5bd423"
    sha256 cellar: :any, x86_64_linux:  "ee78de8dfb2279894e0d00d9f223f3d6014cdbdcd97ff46d75fb8359396b0b3c"
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
