class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/v0.5.0.tar.gz"
  sha256 "b778dd72ee2251f4fe9e2666ee3fe1c26f06f517c3ffce572416db067546536c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb3038ca004157e4e7275ecfb3bce34d430651fda20dfe6044658bdb3c2b3afe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71dd2cacce7a57fca4255f6aa59bea0b03449d13334a2c98ba817401dc41da95"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf28d959d6624a6e63b26178e45df73bca24ce18647ff034fbd7ab72c46aafd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e282401723657985765d781b1fc6b23ff47ca669fe12d7aba5efe4d5a5f75bab"
    sha256 cellar: :any_skip_relocation, catalina:       "bd63b2e2268796e20ef1a3b12fa8460bea3e37c954fc7ca1abd8d756d39361ed"
    sha256 cellar: :any_skip_relocation, mojave:         "43e49af5bf99efa53964ccfddffd2e8061ce3b1aac3707ea389ee1f19dd80fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e99649702a2d0db3cf07442af0b960d04a194c62e4062e6a72012f41b5f81d"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      bin.install "wasm3"
    end
    # fib32.wasm is used for testing
    prefix.install "test/lang/fib32.wasm"
  end

  test do
    # Run function fib(24) and check the result is 46368
    assert_equal "Result: 46368", shell_output("#{bin}/wasm3 --func fib #{prefix}/fib32.wasm 24 2>&1").strip
  end
end
