class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.0.0.tar.gz"
  sha256 "f0d86dcd98882a7459f10e58671acf233b7d00f50dffe32f5770ab3bf850a9a6"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec6e994d11545a64ffb754dbdbdab9831b62c98f65156613761217e812d1f934"
    sha256 cellar: :any_skip_relocation, big_sur:       "117e7170049d7a22f19eb3a886a672ee25a025055c626745abb8dc159df9954c"
    sha256 cellar: :any_skip_relocation, catalina:      "a3d8d4564d2ca240d5410e2d4186b081f270f630b45becf31776668503a4a690"
    sha256 cellar: :any_skip_relocation, mojave:        "ca3bb35344bf5e3269e123842f622180939b3b240f0e98f1824ca79305212cae"
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
