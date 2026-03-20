class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.245.1.tar.gz"
  sha256 "f8fc02ceec50f0188e4128159535e6c4195594e74c56ecc1db3113e62feb477d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4533930b3f064959246d3e5c4a7b3d7b2340c2aa3bf4c85f8070cfec97cbfadc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "523e6159490f864217fd6cd134a9c1fe40ff6f083d40f437da9abed6a530bd2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34de4b048913c77097aa5e0a92a6215c20675a681e6c57a210a92f97848ce616"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5e4913fce02d4c387ee2e2826a45fbcec74c3294db6cf04f3323db4dcd88899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aef3b41adc606158f9a88ceacb71b761095b05d87e6a399d70da475631ee2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f36ad7fa1f9c89c27c0f5403d13b7f122ceb8738031b03e473ebac4957bba40"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
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
