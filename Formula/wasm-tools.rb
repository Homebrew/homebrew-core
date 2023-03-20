class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.27.tar.gz"
  sha256 "e7be9fa9af3c6a6c14c6851481bce9b80099c442480e778010b01f479b486ada"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b7a381e54ade239b4a042e9326a1b664c7252955acab82e6712c924b1287d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e5d2c86875a1f1409851b8f453e863944cdcf473ed39a81cdfd43dac2a4769"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b02baab172022709a03fab314a0a704cd538054c8f60404698f1229a85ade4ba"
    sha256 cellar: :any_skip_relocation, ventura:        "483fa84dd9521106a87dfda4d58b5734ddce12896c2c516c0ca61b24064ec835"
    sha256 cellar: :any_skip_relocation, monterey:       "3221a98ba32b01d9abda988d7ed2ad181c176627f89f154e773f5abe187aa70f"
    sha256 cellar: :any_skip_relocation, big_sur:        "151575dc7ebcc7680800951aef82446409303589538c818e34ef594df80a9075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bde0fb387ea4c4ef76059fec225fd5ff290a1d1464e79eb78f97ce408dae0b"
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
