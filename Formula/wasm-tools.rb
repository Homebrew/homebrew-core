class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.15.tar.gz"
  sha256 "f8f418712bc2ce4b2dd07a605335bb7eb2d9aea862203d476999de6f8e0b5ab7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fadcc7f4989311be7170958e4100c4f676b98d6d4f95ce7ec4ff4a141b357bdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d444a7663b6b4d2dbcb0040979bb0ef7ed60a6e4a01160422a11ba8aa251348f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06ce9370c86a400e9e6a8b751bc29eeaa81960ac202f055b6abdbea078e8e210"
    sha256 cellar: :any_skip_relocation, monterey:       "99e0abbdc3cd055763830d43c960b94458f117401f5aeca4aba2824beffebb61"
    sha256 cellar: :any_skip_relocation, big_sur:        "022433d58df244e4adc33d6a6d3b29ad4446602f95d1da26d9810c9c3a053575"
    sha256 cellar: :any_skip_relocation, catalina:       "811b99a7d9785da76f830f20fc4935f945dcb3e47adf118c993bee84853f00b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234d292e199d0ffbbdb4ace8d25778094b237dd9e7f1c30612c4504f227fe798"
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
