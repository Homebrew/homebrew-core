class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.34.0",
      revision: "39b88e4e9e8115e4a9da2c1e3423459edf0a648e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cd332068f1e32e92edcbdc5468d4081656e839be1c132ff029c9bdc1029362e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d65fd688253ed611c2940ce0f853b02dc9e5a7fe7c5dca0b9dd530e923ee5013"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc94eff30d625a7f7d92d45a35fb1e8ba743ddc2d688c4ba1c584b66ac80bbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6eec6a20f4ce99e21232dbf051ed94cd57a55e84dba24a059252faa636440a1"
    sha256 cellar: :any_skip_relocation, catalina:       "f36d52af1655ee10941b9d1ef07303ce7f1b782c85ff59271e6ec0825c0d4bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f163750e7c40e9395bef76b623131958f972fed86c28277cc1ad8bb84f3a5199"
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
