class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.16.tar.gz"
  sha256 "0fb71dc646b27840a2d03527d787493ebb8cc8d7878c97f1cb9f4bef1e0976d4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a609acb8980bc732dce1371a5a22e67070fe5c94d5df6b2590eaec8cf249ad04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d22db18fe6f158071f5b342253bcdaeacb3cfc2963268050dcc331f7e6b678c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac024cd8fb8610259732c7a1b234ee260fd46649edf8791c98aee0f8f68e507c"
    sha256 cellar: :any_skip_relocation, monterey:       "14b700e73923d9e6c0b9f4253cceb095fd0bf2e951b0c84d0d3b95a0bfd006c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9cb60146c463b72611905171c52e3f37d72380dd44c95dfa0109c19e9f8d302"
    sha256 cellar: :any_skip_relocation, catalina:       "809e6c186e3482e5612a04f12ddea39f3b1e953f0427b1d3fc7ef46d8b4c71a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576e2172bb2e798f30582aea9d2b9176b7fa708456b8a6a239c94b6d09bd706f"
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
