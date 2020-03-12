class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.16.0.tar.gz"
  sha256 "1adc0ad517f7bbb7c4b111fc06e2d6a019d336448b943c56f2ab257a8066464b"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f952dc02f6b8be47ae19abaa1e3dd8b1cc514494113a18dccfd5c9eabc29792c" => :catalina
    sha256 "1785f2610300b3d735517c390cd8d189db23a6e15a07ef22c74f29b88b6cc1f1" => :mojave
    sha256 "295094ada5c3e3cd220bc7ca0b68a8fe868b370947b05692d703ca8a41fd3177" => :high_sierra
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
