class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.14.1.tar.gz"
  sha256 "e5b582c902e69ebe49491fb3f3b928f53027f3a792304482ffa62bc52093d453"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47eb28f06a7fdae9b9f6a84a15b81788240342e620a0da8e4829298363c25903" => :catalina
    sha256 "2f8e024547bb0beddfcc251919cdbb4d29fcaa584bad4a7f22c2d1d1df3fc1e1" => :mojave
    sha256 "1acbe176f57022decc88bb031f64ae609d5d0de91a1775836a588da154f04725" => :high_sierra
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
