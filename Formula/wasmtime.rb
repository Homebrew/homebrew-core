class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.38.1",
      revision: "9e2adfb34531610d691f74dd3f559bc5b800eb02"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0827746b163fe208f668aa4f12beda83ab39251cd30dd43ff79a10c92248d0a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21989881f10d6c7d6845cb3e4a65047c9285cfcb60a95bd3a3ad522fd3c43844"
    sha256 cellar: :any_skip_relocation, monterey:       "cbf32496bb5fe395a5142eefccb768f6b18767ecefb0d90c20f417e5d2797bc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccf96c0051b4bfaadfee83b030a9fe5dc41d79bc343fdc14209d1716b9bac7be"
    sha256 cellar: :any_skip_relocation, catalina:       "3269a61bf9c7f0c140864f389239e4c5a28fd8c779d83f503e6e3511393da35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9298877d731e877fabd5ae4b896892f2223e1499f15d5dc0d4b86df4b6fb0faa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
