class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.219.1.tar.gz"
  sha256 "16dfd1dfb07bf95f12459fcfd846a23b7afaff1d17ba7aa550091f0aa2f7e5ec"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d457e6cac44beaa70f096495d12609af37bd105ef0b7f929466de9dcaa9c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97cdcdc2beed316c98b7629eaefb8cdd0613db6a7f8cfd154bcf2103d61c440e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14dabf93c7a4001ba2f74bb223e7c3006cf804388ab85e9778bd781c080f2b33"
    sha256 cellar: :any_skip_relocation, sonoma:        "c901e33023127b7283cf958747d6964202130bb1fe99ae4338802ac33dc54115"
    sha256 cellar: :any_skip_relocation, ventura:       "2b9f01756920973f6a5e733eb54b909bbc1f391fa16a6250d810395dea4948f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39989440e05c51fe29db3e99698616134d20a78a09879cbd85d1aa2fa55a91ab"
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
