class Rustpython < Formula
  desc "Python Interpreter written in Rust"
  homepage "https://rustpython.github.io"
  url "https://github.com/RustPython/RustPython/archive/refs/tags/0.5.0.tar.gz"
  sha256 "6fa2bfd6d3a6c0ecb2aae216552ba24ad263546198c8a7b0c03c8111b6389d9c"
  license "MIT"
  head "https://github.com/RustPython/RustPython.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5c86e8851fd6fe9d48ff14a3a2a21ce70df5b6c8e10578801d92dcefb57c8f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507eb7aee8187bc1c145af2740f35283c6c171d4fe99c847ba465f3d884376f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8c185cc3e0f3e06891ce0feb0f92551fc9262c3575cf9283711af7bb8885c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "73d601ed328462e95ac1c711b1b1b9cc4c3b901777e47e842c9873c2bab39e62"
    sha256                               arm64_linux:   "18d1505421182ac5bf45b0fac1a84e9f78f2c8d9a8c3f1707bcb99ff1c090ff7"
    sha256                               x86_64_linux:  "9608e34be5adb1e39746c6f02e22b229ab8391bb56cd6b1739c21902059e83de"
  end

  depends_on "rust" => :build

  uses_from_macos "libffi"

  def install
    # Avoid references to Homebrew shims
    inreplace "crates/vm/build.rs", "std::env::vars_os()",
                                    'std::env::vars_os().filter(|(k, _)| k != "PATH" && k != "RUSTC_WRAPPER")'

    system "cargo", "install", "--features=freeze-stdlib", *std_cargo_args
  end

  test do
    system bin/"rustpython", "-c", "print('Hello, RustPython!')"
    system bin/"rustpython", "-c", "import sys"
    system bin/"rustpython", "-m", "venv", "--without-pip", testpath/".venv"
  end
end
