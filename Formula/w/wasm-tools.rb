class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.42.tar.gz"
  sha256 "cbb030e5e1293d1abfd58ee7aa727e72e3e89ec75f7939d32c5f8279c5a46551"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32e7c2ed6d47b7ea7b498d3575224e1272a1f6a8bfff7d720acdfe18613a8e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed0850d90b252a152a6ab66bd0e637d6c00b5f9da2e00ef87c708bf7905f247d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bd5c5086a4e648187930c445034d892e94d8e827531d1b48fe7c16b22fa1e7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dabd9eeb609d71ff678e9aa1164d19967cb316dacb19cd2fb3cf3119d3dd0c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa0231b74c44b43d68d903bfa8d3d94b590c2ebec528263d9acf57742049c311"
    sha256 cellar: :any_skip_relocation, ventura:        "bd922acb31b22c327d695d4f95fd2441410f17c3dd89231fa7b7254edd831231"
    sha256 cellar: :any_skip_relocation, monterey:       "dcb02e19a5c267a4a9c59f59e2861a5932243ed11b82020819063074db8f2952"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8b59af8e69fae4d03ded2c310827b23af78877e232c3dbe0ba27cb3e3a72d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "688160c1bedc786aa4ddac9b8c3fa7323fa3a237fabfa861880a827e95f6f431"
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
