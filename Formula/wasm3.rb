class Wasm3 < Formula
  desc "The fastest WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/v0.4.7.tar.gz"
  sha256 "11e863a643f605d62a5276e342abb01a65d33d138d01ea0070622a3f78fa1bd5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e961b5a0ab02691fe707568a0975fb1b77c75b1e949cff863117efc4eb23f8" => :catalina
    sha256 "263421ab14ca11c25dce074033945db85a5f333fc2c7715a1245b3826beef72e" => :mojave
    sha256 "4b36e31ed5c9c109cefad55fc126091f60e416c6c1a846a636ac8d789f8bc7dd" => :high_sierra
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
