class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b778dd72ee2251f4fe9e2666ee3fe1c26f06f517c3ffce572416db067546536c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e1474dcff8363a2a7dcb417ad9283451a35d4093b04b6ab3733322fff4e7ccd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "680ffd68e28697616852a52512fb9f5554be62d626bead5fd48f88c1467e7c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c9cf7f5b53013777afa1f71208a33be93101782cd587b1b4820e6e734849260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb3038ca004157e4e7275ecfb3bce34d430651fda20dfe6044658bdb3c2b3afe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71dd2cacce7a57fca4255f6aa59bea0b03449d13334a2c98ba817401dc41da95"
    sha256 cellar: :any_skip_relocation, sonoma:         "29c820f142977e9bfd84e4b9c7b27e6bc48424f5379028bea718db0cca0d4c27"
    sha256 cellar: :any_skip_relocation, ventura:        "4e11dd228c6d8bdbd476174e43104fb3be6666f4af45dd43bab75a85c0bd4a64"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf28d959d6624a6e63b26178e45df73bca24ce18647ff034fbd7ab72c46aafd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e282401723657985765d781b1fc6b23ff47ca669fe12d7aba5efe4d5a5f75bab"
    sha256 cellar: :any_skip_relocation, catalina:       "bd63b2e2268796e20ef1a3b12fa8460bea3e37c954fc7ca1abd8d756d39361ed"
    sha256 cellar: :any_skip_relocation, mojave:         "43e49af5bf99efa53964ccfddffd2e8061ce3b1aac3707ea389ee1f19dd80fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e99649702a2d0db3cf07442af0b960d04a194c62e4062e6a72012f41b5f81d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/wasm3"
  end

  test do
    resource "homebrew-fib32.wasm" do
      url "https://github.com/wasm3/wasm3/raw/ae7b69b6d2f4d8561c907d1714d7e68b48cddd9e/test/lang/fib32.wasm"
      sha256 "80073d9035c403b6caf62252600c5bda29cf2fb5e3f814ba723640fe047a6b87"
    end

    testpath.install resource("homebrew-fib32.wasm")

    # Run function fib(24) and check the result is 46368
    assert_equal "Result: 46368", shell_output("#{bin}/wasm3 --func fib fib32.wasm 24 2>&1").strip
  end
end
