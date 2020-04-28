class Wasm3 < Formula
  desc "The fastest WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/v0.4.7.tar.gz"
  sha256 "11e863a643f605d62a5276e342abb01a65d33d138d01ea0070622a3f78fa1bd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "42e440fbce683dcaa195d378c8055c6c64b249059b36482f4563c04f95887133" => :catalina
    sha256 "10c4261bfa7dace1846c8da883f641df23f223ae84f6516a407ea5170fa6847e" => :mojave
    sha256 "422987721304957a1af0fff5bcc1a5628f8624809510568790e8aabe51561132" => :high_sierra
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
