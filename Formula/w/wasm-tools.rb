class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.39.tar.gz"
  sha256 "b1269f324de5a1b9a60e6d149025d7163a562911e0a438e4b38d4e455f803cde"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7ac8822cf22f31f289c01ce6fdc5e27e3d24d71962e38b106faf8b81359593e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b1110e866233b8c384542b3f8082937235ad37045238257088431ff2a4b6e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c14e0c4d14de582fbead93dfbb7136334190011fc5c193ae3c4b3f67c4fb798"
    sha256 cellar: :any_skip_relocation, ventura:        "40003d44e8c3073111cfe64c880afb33427093a52b99d2402c8e1e78a54caa5e"
    sha256 cellar: :any_skip_relocation, monterey:       "30f82b5b9349bb338b6010258bb4eb0ee14ecf5bdbe9587cd37d506bf26c7a20"
    sha256 cellar: :any_skip_relocation, big_sur:        "80251fb0c16a0377de52527af9b325ceb52921c80985c28702b411f9bb9491a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ebdbcbfcf592b886ce4f77e2ecd3974a347780b7bd68dd27eede0b5090b5ad"
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
