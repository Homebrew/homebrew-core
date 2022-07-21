class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.39.0",
      revision: "c780594056042c4065ec86529e9b8509139c6991"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc4e106ae2b2e06b97d97c49846e71ddbea93acdb76e5ea138e934632aed1816"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b3b055cfe03903170fe06f4d5d12c01db6eac84a9cd967cda28ccee0306c215"
    sha256 cellar: :any_skip_relocation, monterey:       "4f51dc86fd9bc63d60b71638a59341cf7c0ce5380a2af34e6e939048f179b56b"
    sha256 cellar: :any_skip_relocation, big_sur:        "716dc0c2dc95374f85ebd1bd25c8ceecbcfd42e6c936d09f4b64832443c414d0"
    sha256 cellar: :any_skip_relocation, catalina:       "63c885e975f5159a354c77174f8d8ea280211b387fcbe244f45bca6d380c5210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f295a6fbd2c9b27979f5e00043000f8b0d8cc943b1ea4f8816e8f6c450e49358"
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
