class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.40.tar.gz"
  sha256 "3cb15b5aed7bd7dc54e59b8749e28e72cdd85527c24c292f290be186bbe161de"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627cc2791c1f94031e47b9daa64d185f00ccd34cc4049b36002b201792357d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4215b55ffc88464d1b9e3b2f5430482dcba2101a09292885b934cc15701a5fee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7eb7162743cfbb81aa97a706996c8158fd7d420ddf0da13054d2af0e413ad0cc"
    sha256 cellar: :any_skip_relocation, ventura:        "8515bedafc8fd58e0ab1a555db2d2d3e5c5a1a13972cf80b4022e56a482695b6"
    sha256 cellar: :any_skip_relocation, monterey:       "7970e5ff233fd4d1d14c0bf462a58270c9266a27d3b90436d183a1ab5bcddde2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d2d2ac3dc3087a3b264b571dc66da115a45ff4d869c2ac679b1de3b5a705e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d5802ecb3539db39f90b2d0c6d99eb44b7fe2be9b77324f80db37acd27419c"
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
