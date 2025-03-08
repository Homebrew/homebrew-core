class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.227.1.tar.gz"
  sha256 "a806566b60fa59d76704b9a3493b9bb7f33a6c7430da0f94f924c41aea6684b4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ec4091ea2475f7f131f108ca56480b33a043c8f505349aa717ebb99fbc494f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495feb234f96d1404021950fd77e5c264270df89f5531e6216d74b0df002804d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f5c6a451f8edd2d22742fb6f77ebe26d9309fbc0bca25ceddd80aaa0b0d57c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "007c2bc4a75b1c806e71e5a18a941c7f157dd2886af8424e8eb4b733ca76d3e1"
    sha256 cellar: :any_skip_relocation, ventura:       "9e5aec22b88c233642643082d225885a71f0d1230ad4d51c2ee74ab6f2250fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3810cb0b12a72fd62c7b767e3665408efc7678a434633eec4744f26885c64af"
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
