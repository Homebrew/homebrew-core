class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "141aacceb80007735b7f9ca9ce76b439febaacfc069bec7e8bdd1883b4ac0e85"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7089f2de438746fa60ca28d24dfbaa22877d873a64cea22d54e29c6fd1cdb88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9a64d8244872bed39b80d5de8d9c59bb0bd07ae992de52ba320028e05085c4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0ffdba3d8aa12d90429998c8ec7fc68eee60987e18c32b7ce7f5e25d8f71fb"
    sha256 cellar: :any_skip_relocation, ventura:        "b62ac537b8817de4648e29371097abb62d26c3d56abfd04a386eb73f51901eff"
    sha256 cellar: :any_skip_relocation, monterey:       "400f61a29c839954bc3a4a068f567390fb437813503f9e4ab4aab9d0943024c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8475b7e03fdf0b64e9fc5f96623de0a4786aa0f3ee660492044403547546b623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93f36c345e30feb232332dd2e10f55f2a7c8cad678281eedc3d9b9fe2e70450"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
