class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v7.0.0",
      revision: "0d8b737cbe0d4c8c6a939064995fd03d9afdb2b8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc3b5dc8c6ef062c2f9a58ede833cc094b00d9ee769c2d4ea3fc87bc785fd6a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bef254a62c5eac4073d1aa43d068fb58fbc9b53176eb8add89b1d54489f46e07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e2d9298087b52f9f4b19f92170e748b6d6dd17b78f0e3339f9c0f9b56be373"
    sha256 cellar: :any_skip_relocation, ventura:        "433dff36c9344c3883932dd370b7abace13bc97eb34630b4ec75b33f0b03e52b"
    sha256 cellar: :any_skip_relocation, monterey:       "785d26f68a26fc424910099919da924d80fa7d874f2dbc30e685cc23d33006dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "60526c8b541d3ac1c4680a5d31594f8e0156fd5de9ecc20e9cc4235f88c9e68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd1a988018ff87926381e6378632f9606a8871ff8d36ec0d1247c7877a476a91"
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
