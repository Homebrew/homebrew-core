class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/v0.4.8.tar.gz"
  sha256 "75a1736d4616e3463b29eece86ca4f03b687503bee81601381aba91e0119ea68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a89be08c7ff241a0a624161b333d9d08c3ebd4539fb4499d2fa96bb5a5c5e31d"
    sha256 cellar: :any_skip_relocation, big_sur:       "296862636f23bda386da3d469e6bd22e79959203d8960e457777e7ea88952978"
    sha256 cellar: :any_skip_relocation, catalina:      "94625f80433b1af43daba906cc715d78891e202f92d323fae9164efbc2fa76ed"
    sha256 cellar: :any_skip_relocation, mojave:        "e7aac098bda9f38e0f10778b82bcd0b08e88f7834d9a0e511dc6d4f7536ae74d"
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
