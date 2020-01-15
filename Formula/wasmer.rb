class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.12.0.tar.gz"
  sha256 "cb6c70026f29f09248cf80aa0406ef6a7c7100d2bef1809211efc621967a52c3"
  head "https://github.com/wasmerio/wasmer.git"

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
