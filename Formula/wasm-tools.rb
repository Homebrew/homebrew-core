class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.9.tar.gz"
  sha256 "bd3ae3daab5bbe15edbb89ccdde492f4a3e39b962ff8023dca69f48c114d418e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3c31f6ec47164d6fa6cdf40c3debd4b2baa9cbb86f96cf8efb1667c6dcd3b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a69ecbddddb7cf00d426c72f0fdff23c3ae9d1c754cf3d8419914531e223aaea"
    sha256 cellar: :any_skip_relocation, monterey:       "93398bfb05cddeb164d390352fd306f5e06e126b3bed4b59153bc43395548e4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b53ce243108058eb114af801a62389e6118115110f9efcf24a93b9ec1d38b3d"
    sha256 cellar: :any_skip_relocation, catalina:       "14e6cfdb21ffd66ddccbfb532c989c20c3dde1268eb33800d9774ec94570b8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3a095dc30527e493476a2e5bade811ed82df266734e6a37b95b5351123e655"
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
