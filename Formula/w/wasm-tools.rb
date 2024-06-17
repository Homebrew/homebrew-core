class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.60.tar.gz"
  sha256 "397fdfbcc3d1352291250d89d5caad8c8d50a6b1d22d14ed7b74a247ce08ff31"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a139282356c6f7f06ed9dd7d248a20d916aa0b66747bd3f00cac0b6d3a765f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c728de36ccda69b569452a6cb63b6ff07bcb7f707f3c70ca2d29525341a3a10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4e170f725671f2db0cebb70e9f5cc021dc8d1f38599bead756217f2723663a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "65877d74a431f7557fe780625ed7a7e47e05c1f958cb1220592429f459f613b5"
    sha256 cellar: :any_skip_relocation, ventura:        "9848a9b4d3babacdc03b99944e037bc749141fb56cfe745d2877702032b28a30"
    sha256 cellar: :any_skip_relocation, monterey:       "566a1470ae50093847a49f4ce77ca55643be3aec9ac1467461e9b150293a263b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56b28d48187d953ba9facebbec9fa67bdd7a8756f64223b88792c7a1ee80765"
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
