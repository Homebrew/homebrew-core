class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.263.0.tar.gz"
  sha256 "2c5eaf1006b7302c154c9aefb19bb30bad480ccc4e45cf3c6395ae9dc8073058"
  license any_of: [
    { "Apache-2.0" => { with: "LLVM-exception" } },
    "Apache-2.0",
    "MIT",
  ]
  compatibility_version 1
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69daaae6cb407f63dcf9c843939e0e6093b7ace4e5e00315bf0b41f1e7502250"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "285abece21e8bcb49110a3fdda7addd8bd2b5c4ca3b87f765c663ae427557ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec8a9b9552012e7c08754d660df2788d645e752914bb7b7f583f13525efdcdf4"
    sha256 cellar: :any,                 arm64_linux:       "074bb35ca4390392a7d7ac246b1ae3496c3e3ad893e0e4cfe90888b1cbaf6fcb"
    sha256 cellar: :any,                 x86_64_linux:      "bd3d76f71a969ddc1993f1ab2aba7ad3c0d1b76f50c83721794b7a71a07aeda9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
