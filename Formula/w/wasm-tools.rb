class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.223.0.tar.gz"
  sha256 "bded9fb68df0fa14f80a37609c272c20a9f35b20c897b9900305ccaa3f93d6d2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d849735b4a2f10508825ce497a5f55e752b2f7fd11a465dc7ef1f3d36126922b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2724d7dc1af71d8d38c57567fb47295b32c4d2c1b4461aca916f62cb01cb07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84e4e96f3f1271ec51b8414ab9fafce59638e1cfc81c3967918164f9ba703a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "937e128405d5660c23a624d9d23c06b3652a9cab7a331fb29661c93b44db9a55"
    sha256 cellar: :any_skip_relocation, ventura:       "4d726f2dd82b5eba3e8507de23d2b449a74aba915751eb4e184f463982393d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec4d88949e7d07d8e9d63f326271bf467f8a50f7f8e855029d557e9b279fafe"
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
