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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "781e3cf14b36aa849d51837b2a0de80ab1c2fb4d37c239278bc669fd18e0cc4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65d7f5fcb0e797a61543cd1ea47bd1a4bf8f1622111b6ebc4a607ff538b78606"
    sha256 cellar: :any_skip_relocation, monterey:       "5d306fe1223806074e26e72fd48db3cc56b8057962200f73fcc5b307a000dfa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "898e7ce5a4c584f83303155641e0f5e9dd700cceda36976b5b7e8c04cd6ed718"
    sha256 cellar: :any_skip_relocation, catalina:       "cace1c41cfba80a6b68ff5e0cc7d9ac67612f021d9b3944a2597f767d3602bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade3afa42dc2cce3aa7cc86bbab639152f9638396d79687b8fc0308ad8f85dbf"
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
