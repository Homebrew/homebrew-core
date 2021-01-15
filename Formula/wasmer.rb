class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/1.0.1.tar.gz"
  sha256 "ca5ea30bfd0700b5f89dace19516991dbc9ef38cf451f5bf11cab283e5f12777"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b83a60aa7f2018513ac7305767c6fb34973f3c92c52200a94976cefab9db645" => :big_sur
    sha256 "4f9d850db5f2abb4807677d3352437538fdad56bd4d4961769bff79c2c5f92ef" => :arm64_big_sur
    sha256 "d07f5961ac923a8ed57bcbe28733906420c4d4532b32f2b0d5cca383b38e4bfe" => :catalina
    sha256 "263977f8006ad6e863d39023f816754ddf68160e06d285ef7321e118587982cc" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  def install
    chdir "lib/cli" do
      system "cargo", "install", "--features", "cranelift", *std_cargo_args
    end
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
