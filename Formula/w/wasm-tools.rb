class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.47.tar.gz"
  sha256 "5fc1dcaa2a383cb748ebafdf87e361018d3d191f9e0500c98aa9de446f1af88e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b723c2c7f35bf1a1ac6c09fb39a81e1d05aafbd5239bb39d666d38670eb2ea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ef11d94b409a8ade8a4a02e4dd0e544b011e42de0ad9b6c1551e7b75eeffd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "577d24bf0dc2f06ccec08a6d6da1585f327a6d384557b7fba27a5de4dfdda1d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "27c00baf01ceadd33cfd36378352e0b7ebf0d9b2acee5746e83ba2418e9011dd"
    sha256 cellar: :any_skip_relocation, ventura:        "8283e36a62069e52cfe36c6ef3ac86a0c79efdc391a03881dfc197d419219c9b"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2e15a890c981cbb0f8903919ce13999c819a308c5fee08240f8004f0aaabe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01c3a560b4bf1f4aa21b7c22d049021b5aac704f9a13ed08cc380cb99afb2be"
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
