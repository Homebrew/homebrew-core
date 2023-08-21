class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v11.0.1",
      revision: "acd0a9e7446710f67f4fd15da20a1870936ed0ed"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ef9e44e30eb89cab43b2c52ab7dbf231f4ca455637d95303edd5e6e0644b6d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9da419c5a7df72173c6bd1831bfec1dee4ded3e1f1ae3f591b8fb1a18415f371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21b62a68165bee2e81fcc33ff81f5eb491affb9022f27cbcfa6a8f7b51396e73"
    sha256 cellar: :any_skip_relocation, ventura:        "b34f08dfd634cb752700683ec6edd1df3b451f1a706135a95bff4482a8e993a4"
    sha256 cellar: :any_skip_relocation, monterey:       "50267885a832699a2b1e4f0354843ad9af54e69adbbd9d59555cfc424bb4a22e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dc1fbecfee8c917dee48a1b04833142dd2f913bc08512b96bd4a0a14d3f5e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac902db833ca0355cd78f15e9fd926316c3a673944fa81c4546a887fc9f7d859"
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
