class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.37.0",
      revision: "e54c805d511303295c690527d5e544b5dd919c7f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e5d31a4e8a177472c3802046694b05566a470f7b823767b9954887ff4bcd6db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c03ba22dc761bb52fa8c6e22c3b126fc8e428dda589f6f9e4eda14e14b838fa"
    sha256 cellar: :any_skip_relocation, monterey:       "2491f71f854a3399d3ad2b1bfe7079ce5d622c1f510c2bdecb825b85a329548f"
    sha256 cellar: :any_skip_relocation, big_sur:        "13f2c88426a30fc640c849274495676752efc86cae99c0d16620d88aba498494"
    sha256 cellar: :any_skip_relocation, catalina:       "342f36ca7b196e1d9b7d6b9ed82383b0dc6ec9bff159f0d0e72f92c243bff71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39195d69384811ccd7b667baae1b3fe12e7a3faec201fac9b41f6c43bb348052"
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
