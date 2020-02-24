class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.14.0.tar.gz"
  sha256 "ff1b4a07ca48105cfb2ff96662f24de304ebb657bb51429574702c91f3aaf9bd"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c97cb073468f0de1533066fb87f6f0df6fa22edf29fdab83ced5ac00c6604b" => :catalina
    sha256 "5ef4f8973b8398195bf7654088f9cbaac51d0ac9e2aeeff7f3438eb8d91ec5cc" => :mojave
    sha256 "19d0b8f30090cd72c60a10f10f0163d5fb620fb78159bad898efd57b4db46e71" => :high_sierra
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
