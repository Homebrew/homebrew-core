class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.7/tio-2.7.tar.xz"
  sha256 "bf8fe434848c2c1b6540af0b42503c986068176ddc1a988cf02e521e7de5daa5"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a1b8ce961777af94d3361b9c4aec4a2d9f57add524fd40b5afa021785ef9b64b"
    sha256 cellar: :any,                 arm64_ventura:  "a9d5b2c34c78cc35ef3b94694ec57e2fced21f5a3325c176db5f40c8c5612af0"
    sha256 cellar: :any,                 arm64_monterey: "d1a647be1a31d1ea4f14a0c0019c715608292a5671f8fa174089da53e86eebef"
    sha256 cellar: :any,                 sonoma:         "e0514e02a258a737cd6a46695dc20a53f7dade098b2741cd2f87c498b022744f"
    sha256 cellar: :any,                 ventura:        "3762abfb40e59e97bcf8f057a859d070bcb3cabd99c31e1c24123346b80caa5f"
    sha256 cellar: :any,                 monterey:       "5a485facc09cc08332ee5a16222611b337d975bfec04d96714e4a3a9f51509a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84db12554c4370bd7f752b935a660bee6dc8a66fd75dce0ac2f0c63217ae97a2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "inih"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
    assert_match expected, output
  end
end
