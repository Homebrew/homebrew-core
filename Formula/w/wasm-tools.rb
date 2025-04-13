class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.228.0.tar.gz"
  sha256 "5cf505cbae1f2e93270812c4c2266be47954f470ed3d9e0f2316113f71540760"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65d6aa1e37c843ac8f6d0e1947645b1eec02c564d6d9fc50eb4fdf5ca3c11071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f8072121e70aed0258a0ebd5cde3311e5599ebf157dcdbbc0a237f06f3a7062"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73b47508392eb5fc6174191f3309925f038ee57ec1225162dba1dc0cf1fc0ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f56c4170e8327df939df04fdf15f7df0e37355c704353ed7e223e8da4ae605"
    sha256 cellar: :any_skip_relocation, ventura:       "d4329ad254a9575669150eccc7560704f93af4efa283472c5fa8cf326dfc0a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283dfa1c465d48c0764c2d912ab3a95629004991773284c6456ba1cb134bfe7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dff467aa95e8055e1edbb5c6bc7af79bac82cfd6ff69e48c4208071df8dcbbc"
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
