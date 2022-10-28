class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.13.tar.gz"
  sha256 "822bcfb42e60841a6180162b8de9b8234855d8c53a93b979488bbb9d777517fa"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c066768353a7098f061cea59f52cff9a3336b921e544c7fe1dc693e0af6eb3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f9ff4109a21e6b9349d1f11920373016ca0535e80b263fc57b9e14def435bfe"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc94bd978dcc7b8bdc7b4820a9d33b8cb7190885fb2d765aa155ffde78863c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aafa15124e277b4f9c518b3981cd8ad0cadd852ca14062a5481c0feceed6e097"
    sha256 cellar: :any_skip_relocation, catalina:       "9cc5a29f04fcd235a007dabac4bf7a0b16220e2974ddfea126bbc50828d840f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3d57cd00e7dafca15a942ea32d65af5ad42d489c91ccc4a0025d0e052f710b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
