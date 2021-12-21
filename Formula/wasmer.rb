class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/2.1.1.tar.gz"
  sha256 "f2ca1f3c48983de854b01c87b521e02245654f235d48d339a0e25229e184a322"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b105f5c06e6869991d7db08ebb6d1efdc6a0e72991dc0940b227f9b455e37a56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4adb6f84ff9ec0a0200bcbcf2fc918df1cca8aa8a6684ce360be863456ec2405"
    sha256 cellar: :any_skip_relocation, monterey:       "75ee587ce18720671c3626cfe72416d8ea271c6ebeb12f74e3483592e1f1527f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fffa06eff019f74b361a582ffa95020c90b0a2eed336b15726e21cdf15d40c54"
    sha256 cellar: :any_skip_relocation, catalina:       "13bb98272c3bae45804c66377d2e9d09dcec71529cee606d5fe1c85c119434b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51a5e0efded01ea16c2cbbc172746e8ea07f412477d48ead3b3ee5f083d36a2"
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
