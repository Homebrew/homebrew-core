class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v6.0.1",
      revision: "b6bc33da2bcb466d377fb02f5aa764a667d08e0a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "473874f6fb894318c4103e7da8c9d3d8edd28ecbff990bcf348770ce01276394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c190052b52b39767e411c775c27e008b580383804d8b0be549eebf7978adef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "933eb376c1a0f377e0d5a43849ceacc4ed9fa84d84153bfcbc49d2ca6db26335"
    sha256 cellar: :any_skip_relocation, ventura:        "077c2403af47e0613a52adfc6f8afc3bc1861414c8b8c1d13b6ff3bd8a59f608"
    sha256 cellar: :any_skip_relocation, monterey:       "cf2f1caf0cd0e8fd4b65616455ecdd0546dd9ac170f14e6ca75fa0dece213a7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f34460f548a7f2cea54860a6ff3b503d5781cf0e9e9a95134da5da08868d10e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a78e5d4f31287236d45a2d87c1275542383f533ba974def6b127ebfe27cc09b"
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
