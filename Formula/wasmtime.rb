class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v1.0.1",
      revision: "c63087ff668fbdffe326c7b48401acbbf0e82a65"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1984676ac7728b6a58b5a835b93deaf26db0479d39bfeb72efad768925490686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5fa5581ed9c1e6f3f7b555a9c2197ede25c6057a2de493a2b7b5a3896fade0"
    sha256 cellar: :any_skip_relocation, monterey:       "4e4a66d76c9dc6d3127a0cd8ad03152f43a8c59b6c22249c0f2c3be826c9f560"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cff634438b39d839d1bf569827fc37ee8c447dd1665b0a2a702dab6368b563c"
    sha256 cellar: :any_skip_relocation, catalina:       "58f4473a45904f5b60e2917c0ca344534ee8f077d6c892fc757de1235c0a28cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e108aface3f129c36fb5adbbc252f62ec1dfb1deef81b33bd571793e26ae0a"
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
