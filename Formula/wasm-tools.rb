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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f25cf7217d595a2bba65077462ba8509bcca70b01ba4a9a29e4fb6f360ffab51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8ef9592059abdbb571297617b25ddd89931b823fbffea1bb207803907bda3b1"
    sha256 cellar: :any_skip_relocation, monterey:       "b19c2558f26651e84572445fd5aaf279efadd17f7986504a6488204d1d6990f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "07632431f0ce2b67f0f77fedc8e3cf21112b1873204fb3e83b5e556a243a0b27"
    sha256 cellar: :any_skip_relocation, catalina:       "a461ae41fc12be501705ece0dbdd158fed07a131792fb9811a8cd8be80980f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3351dedab712420f926fac59a1be1504e25f308ba1ba8f9195b414b0c04f4fb"
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
