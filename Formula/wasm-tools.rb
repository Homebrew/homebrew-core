class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.35.tar.gz"
  sha256 "4483740e7e3aba81758c3676d9fdec00a132575e72f8c9b29699647db5054e40"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1d065f57f48e79614f89fd99ae482ce6f510da50ae1a049c38171f0b373d0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "709bfaa0c4f2ba92b6b8babec67b59fdd064505ebca7700d469c435e0bc24121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b4d20c17e2209eb17d933a857db452b65ab0b79ee9d5809380b84d7f4ca2d40"
    sha256 cellar: :any_skip_relocation, ventura:        "31b651b143ca061d7c8a30d10f76c2145b082b70556aab45504c386ef42e32df"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe37acd2666bc45c043dae729fb428592396a369d4c26f40b51828b45c27d79"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a79579a872e8b58a3fe100e8fab6e9d1d88ea84d04b65aa0c5938df8c196b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fcc7934b09e1b00304e1f1c72cbc0d44139b3f55444247c0666b1281f46392c"
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
