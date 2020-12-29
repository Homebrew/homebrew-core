class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/v0.4.8.tar.gz"
  sha256 "75a1736d4616e3463b29eece86ca4f03b687503bee81601381aba91e0119ea68"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "39b3cff2a02da9e73b7821b362e42707f02308d9b9985c35f675d0a60e872993" => :big_sur
    sha256 "4b729b5f029bde0dedf4ef309bacd2533313176be5c0974fe72441389bbf8c03" => :arm64_big_sur
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
