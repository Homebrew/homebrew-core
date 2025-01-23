class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.224.0.tar.gz"
  sha256 "04d15543c698e0144abff6816b1e6ebdbdd970bf8620af0f2fc1f0d29854389f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ceb8c06bfc9ba319160c75fa363d8b6a6a74d5314a86585525b2b7ea58f05d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66aeee2ea628cd71ea7647e08bb80f4821c10c20a5693f2448dab0550e7e03cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff27782de3348babc6199dd4493a67cd40f352d29b07079ba53535bfcd07e47c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f296e40a69cbd8e71465efdea2861374324efec68defaaea3901ba492a3d5a44"
    sha256 cellar: :any_skip_relocation, ventura:       "3fedf2ee5d131a76510c2daae32d15ed0faf6c5e72a664c9edd33f0ad45f7c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7d8f6cb0fa2b405864000165423ce9233fd284c906dfce15a9bc2185529177"
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
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
