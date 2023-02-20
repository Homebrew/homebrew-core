class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v6.0.0",
      revision: "c00d3f0542855a13adffffd5f4ff0177dfbdcb34"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b333489a4368f264bd706d24e6a8f1b881fed5a74901ead8eb016297fa0948"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a6c5658d579885d7c2a6436016442660282c13e59f37162e7b28eb70246446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b24cc95aba41f5180bdf0f75436b161897cbcdedaef1489df80f473e5c8e166"
    sha256 cellar: :any_skip_relocation, ventura:        "ac6dcf4dd7848439eebf080eb24e0b77f8e59b9d05af18f15cb5fd60bafbf941"
    sha256 cellar: :any_skip_relocation, monterey:       "2a642e68a5edad7600b246c307a52158dd2a5f741ab05851fd60c0b1858178cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ccbeb9f01946f955a82436d0da92c2606a72a9848cbdffebe9b3d1d18b5a213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbfe26f07812eab569598f7dadb534969591780fea0cf42565f6ace9b0d6b9b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
