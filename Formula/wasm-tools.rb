class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.3.tar.gz"
  sha256 "95684121c3f8ab8de5b46b754a5093a675d56cbfd90fafb23c344f1865964c3d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2495917b186bf420410f7f60fd6a6edf19fe6522e8b9601c1e908df1b9f277f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ccf7b6b8ab736664fccb41ca17413b5c425b7a0c8ee6b659859206af0278e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "6140bc39ff29a773e58da0d89e863bfd514be50005b7bb5604dee85b2543e63e"
    sha256 cellar: :any_skip_relocation, big_sur:        "620875a7b177ab74bb0ab3088549db62556f349778c10f1e1ab6ba823d28dd58"
    sha256 cellar: :any_skip_relocation, catalina:       "51d4acb6b032a04d2ddbbc58eed24a3126ae037f707afd10dd178d8a20f6a920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81930cc76f585a6bb5c484cad1ddf3c3e21b78e7de8f2e674d54cbb98d8e204a"
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
          i32.add)
        (export "sum" (func 0)))
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
