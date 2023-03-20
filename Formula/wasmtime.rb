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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf930b6fe7db0e4eed0f3912e1c0b74a137404213b24a7e2f74520ceada1ed9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26d6005df3821469f40f0a5cd2c82564c4ed55d7faa312fb5a855095ad64284a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c21e9dbc95572098b2234bb8a36110c41581361431b4ab2998a2e56e2adf159e"
    sha256 cellar: :any_skip_relocation, ventura:        "102de4b5c78986de49f2abb374f907ca56c99fcf0619bb863e6139232413a1a5"
    sha256 cellar: :any_skip_relocation, monterey:       "ccfb1db64375800202bdd5a82d618b94d1ce09e02148d977c6139a922d4ccea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef44bb7ca274975e66a241094c07739fec8593443e68a6f901249271be431d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd8a891db34251258e8570a10c8c9954975bef575e32e122e8c0bae699f2e53"
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
