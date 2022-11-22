class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "release-3.0.0",
      revision: "01815a711ca88f38b2e10eddac949d0eaa15d90e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b68628db229e8d67379f36a1bf1e355b14ee4684b35adb073c788e7387fd969"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f08c8c313601bb428ddd020b56ac4bba42e48487fa72d4bcd9a35b19ad325c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10785a7089fc9d11127a662a1facfb21080806e2c18c67a9ee7553de79e08244"
    sha256 cellar: :any_skip_relocation, monterey:       "c42922259a2d947db530429b5a8fdf1a6f773f98a6015841cc620fc5067b984f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed257c052d1415d9720872571d0b8ad2128214570a3dc20c53416913df072733"
    sha256 cellar: :any_skip_relocation, catalina:       "af9563666ce7540f01e65557dff011ff1da0ff9a6479f79328c3f58a82fa4312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f18e9392a6e31e732952cc61f1dcbc04ea8ee217a77837e9020b6f309eda6b2"
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
