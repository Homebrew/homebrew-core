class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.252.0.tar.gz"
  sha256 "1589a4379632b5b44d7b5fca2a3bfcb4c6e39be5de722229cc28328342da6b48"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27488c88a5fed3553b22d398a816b497da82df3d4a59e5c71e68a48799173ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a47923d3b6a2e0a9e9ddd2a180c14a197176fb1ef514ad2ab92e915513e4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358ed1bac350b26e29e1dbcf6e89214778f12780fb503f70f1fd2883747626b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85b0a2e11192a9539cc238ebe0f520297d756e130e4e2bf0c63a37a5fdaac22"
    sha256 cellar: :any,                 arm64_linux:   "d0cb5e63c88192cf191f9174036bb35382660428157ce7bf9379c0d9f67e0c61"
    sha256 cellar: :any,                 x86_64_linux:  "027177bd969b8a9bc583d9806131505d7ed4280293bf11e70d93be22062a2901"
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

    expected = <<~WASM
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    WASM
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
