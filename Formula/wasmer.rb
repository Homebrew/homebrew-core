class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.15.0.tar.gz"
  sha256 "b210ba2fc4aa7a49c96c5dba85188f8f399f64d5e18b4a85ef4b9fc82d2a9612"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eec4528f3e924b39355ae55ef52b49ed5f2943235832d7a8a679f2fff58744d5" => :catalina
    sha256 "64c27de363e8ea456d871088ddcea0ad473f0002a3cf7c3e4a571c4c861144b4" => :mojave
    sha256 "70b309e4cf6e2cc0efca0ba59f771f81e317df5d333363d8ceeb0b7b692b8e0c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "sum([I32(1), I32(2)]) returned [I32(3)]\n", shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
