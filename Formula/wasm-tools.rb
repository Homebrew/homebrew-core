class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.11.tar.gz"
  sha256 "0379cf126315e9679f42671fbe2bc8bdea23e70251d4e8afad94587f77799921"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97595fd8afff2beb796389769e9461cf0573279879a8f7de1346b23e306b882c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9b4ecd8a9719f990b3a55227a99589a36c48c1e8712f7ef1fa3d7263dddf725"
    sha256 cellar: :any_skip_relocation, monterey:       "561d3028ad705d59fb953f4cba0daab7f2672355476449f9032a41a14c5f5891"
    sha256 cellar: :any_skip_relocation, big_sur:        "111dd439cb249fd286d0ff55b908aa21530fda45da79d6bf901fe53427abe68b"
    sha256 cellar: :any_skip_relocation, catalina:       "1ae53fd64711f613ec7e05b9eda71b0bcfa0e9a9969386fd0e511ac5c7a45fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "915349785b437fb084ce6b004c963e251da624ecb854b7662b70e542b0113c2d"
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
