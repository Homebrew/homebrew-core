class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.4.tar.gz"
  sha256 "5ca1ebf67de418d7b953dd9d67620fa1b90d1828321953744a1f69abfecac5ec"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1131377948c9beb1f295fb5dac99fc9269961f374dc78e42d416a9651faf27a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eaf85788687c6eb9784618f1233522ecebc5c5484d660fd7b73e4ac5898e993"
    sha256 cellar: :any_skip_relocation, monterey:       "7b33da5227ce888bbdc2a2838ebc1a14276438940ffb715426e492ca1df5259b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a39caa35b40da420932dee2390c9d15836f1d396c237266d154a6ec93cbe12fc"
    sha256 cellar: :any_skip_relocation, catalina:       "ffd2965050d545c8b29a1380385cb52c482cf2ffc8906dbb0a4f61ab44329190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd04d4ce519fac8e0b423b58d2fe1173af6765b3091f557f866bb724da8071f"
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
