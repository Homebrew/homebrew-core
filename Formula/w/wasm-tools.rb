class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.225.0.tar.gz"
  sha256 "1b3f48c5f4918c7c9abe079cdd782e92594aff171e0f40b6cd79fea4a338bf90"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22cd7a890574debeca1fce70d25d41dd7dd9764d70144476ddd591d820f6bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96cd21009fcb05df92364790452d6480e4507c00533f4ddbd7bdd78a4d14131b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f387999de955a7cdc9c4b99184df835a568a0a361166e31f224b2095467f8daf"
    sha256 cellar: :any_skip_relocation, sonoma:        "276b82572a67d478b29e09843ef6986ca344d0dc2acc9c83f8fe3e39bdd075d5"
    sha256 cellar: :any_skip_relocation, ventura:       "3944a3007ccef62db6051d4f4125fbdfb61fb6100f3ca38ab8b5ebe472cc8728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0062286941c72742ffc24b35b8992f47ce839817b7e5cb031cdd848b45463f75"
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
