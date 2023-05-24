class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.34.tar.gz"
  sha256 "6bf5299d21f16368a4729f21af199408b6b36f9df06028e954445b27389f298c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d87ad019fd88efdf962a3d2d5894b165a2f7b518ae90db0b571c6fad37e346e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee88cfbd419ff02a4b817c4da2443f7cf72c99c433f985c08b98a46b0186c871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a8bbf60d49155cd562f1d94cd69219332ffa0d69cb4b5a95dacc627dc3eb3f8"
    sha256 cellar: :any_skip_relocation, ventura:        "60df2f354c413bf6ac5e511bff2b2d0ae03a8fef4d0c6fb2d3a6adb1285e7734"
    sha256 cellar: :any_skip_relocation, monterey:       "ef977016f3fecbc5b9bd139c29bf40080741e6fd146150abc3b11535caf750d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f8bd92baa39f3f1948ef321f43fed448e0e5a59e0b3e4eeca1de08e94cb8664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49a88042e6a63b917e098c0a612aafd356c47bd916e18e95df7e4fa6c67a0fa"
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
