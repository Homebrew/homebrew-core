class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.7.tar.gz"
  sha256 "d680ce80f70cdb241bcf780e92eca06b3d255f74042c9884391261b3f65ad13a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472d60ba71c33c01a4b9cb2eecf5e1d04977980d98e3a4eaf1085c042e705740"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d242c6d09279d184d24bbec4554c12c5c8be663498599a52c2038f076f44367"
    sha256 cellar: :any_skip_relocation, monterey:       "1e430424583f5ff1b4c198aa0242fc5c12ae872af32a557590f128908c3755ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd053aa9ebb5179ee0f19fb0e77a67030fc297ccd12fa00a8c0f2e2ae03a767b"
    sha256 cellar: :any_skip_relocation, catalina:       "120ac4e49fa55466cebab5b14d17677eb03022ca612c9a32bc33f17ed2651dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b90a174b2a2d0b83099a68f60fda7b5bdb1b9e41655b416535febb8fae0ef9"
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
