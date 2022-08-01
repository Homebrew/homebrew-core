class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.39.1",
      revision: "19b5436ac346b8e61230baeaf18e802db6f0b858"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ac4e98113bf6f1c94057472b114e91e66166c44fa774733aff5509160e8f96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "565219904b25afef49508fa2b5c9a59f8ca8e40a2d1f457155f9c1393ea1c092"
    sha256 cellar: :any_skip_relocation, monterey:       "ea294c2f86a66c571d2aaab62504218f1144bade98b263436257ab3709c96dd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dd043aa21d2c81e1f2de98e0b549e88049f1024e76a0f5fba0f1bee3f49e754"
    sha256 cellar: :any_skip_relocation, catalina:       "db405ecfee7ce708467058c46d7860ed522ac116604623864a70247721a374dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640be7f33d96ef98d9e20b86dced3bd1196a6165f3aef6bf49809de9e02e954c"
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
