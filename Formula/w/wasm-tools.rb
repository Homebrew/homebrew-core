class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.244.0.tar.gz"
  sha256 "405e19e651da2ffc5878b8ded2cfad357c8f9b069512470b17c4a6916249d185"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d5b3c86faa3ac52b4d7dad2f1ebed3b7f7d2cd761cb0dee285ee9ccf19be974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3bf38cdde1f9bc962bd3654068dc7516e96799c887eb512d3291189a328fd11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6871c87e7bfd908994ed60ef2624a1166e70c9bf33069d3ec615dc0bf522b248"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c862d54f506a66af68c8ac6a8c107ac98ab7dfa41da9e8757cb9c3e28487ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f7c1cf784ef1861a7e4e9657848abe704518c8fce164d7e41e2e9d49e5e245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d0ef5ca86de9409e80ac777b29f1b656ba201e44f31a9475a1cebc8b6a0241"
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
