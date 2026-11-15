class Rustpython < Formula
  desc "Python Interpreter written in Rust"
  homepage "https://rustpython.github.io"
  url "https://github.com/RustPython/RustPython/archive/refs/tags/0.6.0.tar.gz"
  sha256 "bf290cf7a70f813758819d895868b2b49b9edea1f10de3524df2cae1f2d58a4d"
  license "MIT"
  head "https://github.com/RustPython/RustPython.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "027b8d2ac35fc6044ce6a29208a751c28d4886f7f3ba8b1688175b27caaa246d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c023db1f504419fcf1b784d729f8d223fcd4a3aaf569d563b10d5712887cd6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efc8dd046f37dbef10db87660808e3893792292e04d4f95088f65b53aa10aef8"
    sha256 cellar: :any,                 arm64_linux:       "41643e1fddef82f23163068ebe0b5d1adea0161be04838266bc053d90c5b0689"
    sha256 cellar: :any,                 x86_64_linux:      "dbd53494f3e85d61dfd47b0ef14e6ec31858d8ce1e2025a57d36917fe58e6109"
  end

  depends_on "rust" => :build

  uses_from_macos "libffi"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--features=freeze-stdlib", *std_cargo_args
  end

  test do
    system bin/"rustpython", "-c", "print('Hello, RustPython!')"
    system bin/"rustpython", "-c", "import sys"
    system bin/"rustpython", "-m", "venv", "--without-pip", testpath/".venv"
  end
end
