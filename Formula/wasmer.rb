class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.17.1.tar.gz"
  sha256 "19c4d6233a31a5b5b825448d94dcd96890979b807edea4242e594526945dbe90"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "751b4b059036dbca254eef935bc03240e1fd559465a376a0cff8f5a41dcd3980" => :catalina
    sha256 "725d2b857e0954b1e2fd8a01021847e168d5daec33cd76c32f90a0ae12fdf422" => :mojave
    sha256 "42ea898c1ebd9c0ac58bf21117c05df6a4726123590444c19173a01586c80c63" => :high_sierra
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
    assert_equal "sum([I32(1), I32(2)]) returned [I32(3)]\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
