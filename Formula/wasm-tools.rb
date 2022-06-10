class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.6.tar.gz"
  sha256 "a11883d8dc168faf9583ed2b49e9418f8e5b11a9cb060de4cdf6ccdaa32c21e5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c90106f2a4d4ff39cc2d84ea4cce2afc311627a539fa4db080c1a0dad1423fe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "260427fbf70c80f5ceec327220edb8c3c33704c8d9401f94233d5fc9cb84d35e"
    sha256 cellar: :any_skip_relocation, monterey:       "161e8ee83636214fb260f0bd48bc82630320d12986ba1b36f525e2a5dd859b10"
    sha256 cellar: :any_skip_relocation, big_sur:        "e29986b3fa5bb7d78f57dee9cf47c7e6ca2d2e3dc5eb2a6a5a39c2713892e4cc"
    sha256 cellar: :any_skip_relocation, catalina:       "f5674b1fb611b4e72d8e1874e5f35e261691babb4d121a2cdd3a91fad33c0a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be26ae9c63bea18c39a1060baf4b3c930cf5b1b6ead1ff84520c82fcee58739"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
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
