class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.13.1.tar.gz"
  sha256 "7347e026b91f7ae693023ddbdd18858d688c74b28c959d6f849336f08d35e1f1"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab4ff5856bfc8fb630de85522d5d8269dbf4685e93a9a6d115693870a1d80d18" => :catalina
    sha256 "d827f5b4452c63faab931f58979ecb7980d02e8a68951095d84214886b0d32d6" => :mojave
    sha256 "164d4d9ac8499ed296945121d620f09420bcb2e7f56664d38fab60ab044039e6" => :high_sierra
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
