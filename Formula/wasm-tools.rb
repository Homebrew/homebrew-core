class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.12.tar.gz"
  sha256 "ed737adcdd298c3f86c516fa15c70efa6faa7365c0099641364c1b23fd09cc69"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275c5e527a53a39eaa153131ae3bc32900600daab7d188a64e02e46b5b5c4577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cbd7ac30db2725df5d4a614c25a4771a9851859e4b46fd3dd3e716171ae3ccd"
    sha256 cellar: :any_skip_relocation, monterey:       "35e226bd69c1b570e2bcdc893ba58902923469835d497c36f8428d4b9296385e"
    sha256 cellar: :any_skip_relocation, big_sur:        "55a6632ac115c0b0725bf098063dde24073652b6ab884cfdc7c4d6c1d14a45bc"
    sha256 cellar: :any_skip_relocation, catalina:       "d27544f97cbb3ec56de44d8bd74276c28f831bb6fc70adefe430ec53c46e13b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfff26d44f3cae13c583f055cce2825f67771fc693b75f2872e674fe1139e2a9"
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
