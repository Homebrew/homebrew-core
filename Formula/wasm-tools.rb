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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd9cc1a8f3c9b70f4e9cc35aba86f846ce909e70f11ced6f56d5bdffbc3ec097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cea633ee498beadc6e4c00fcc49f5dd90721942004efb533a25e9b92def4dbe9"
    sha256 cellar: :any_skip_relocation, monterey:       "59216dcac3d89a196cbd37cb6e8db31308f02583116cf2daf4096db2eff88a49"
    sha256 cellar: :any_skip_relocation, big_sur:        "f95df370d19d8ed5beef188a2960e960d5d2147b2dc3eb81c010d57161807d5b"
    sha256 cellar: :any_skip_relocation, catalina:       "f8ed276e80cc78018a53feda608aa15703cc6fff4088bd640f2cb0aee7bc53aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b298f4043e098d794f450e4b16f5b878efb46b4e135f910a6eab6b88f1eb89"
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
