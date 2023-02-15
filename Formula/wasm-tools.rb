class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.24.tar.gz"
  sha256 "9ed44546483fcffbc7b4fd05e45bf4f7176a4c86b274b1e16f9e4b68a255ac8d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ee7ac4c75c119ebde0b90659b4aa2d79856dc4fa2ede6af19ed59ddcf9da8a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ef14e79c4b36770d53c86ba602ce6a5da01fcc51e46eb632e5d2e9bd66bc6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b0797e75e2da2e264bb13af1a0bbc88bd4d4c7f9e6a6bd2ee8401b3caed5b68"
    sha256 cellar: :any_skip_relocation, ventura:        "67d6c6c482835976c85653a18804382f8af7dc74344feda1fa8e8c34f2c3fdc1"
    sha256 cellar: :any_skip_relocation, monterey:       "02008827b9c6bd145d12cd49d456aaf1cb4692317c1b6c5270312df858631fb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "935ec9b9325973a72ffaa8939ea4ba3a69045d4d050c0dcf54fea54479d98c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea928058e84961592de6f128cac963a19c63436e4e299cb5dc1b55ebc101f49"
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
