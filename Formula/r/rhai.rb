class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://github.com/rhaiscript/rhai/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "29a9f479d027d39e8a26e71b8c0b168e05a9ecaa00387c82cd78806b6917aba1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26301c3c5315b8670e4e01be7b4cf840a27075f5b1657907546690623422859c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b16adc0b72928c0edbbb18ded468b2b5957143e947d66a862870185574fb7b19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cb492dc9a45b02e63a36ba1d94a386d027892da25e9a0c1b471f87f7dfe8719"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1c8dccbb74cb317ea1fafbecc11ddeba059dde9680df8b0cd86c1368289e2fc9"
    sha256 cellar: :any,                 arm64_linux:       "d0d38bcfa90885ef5f0e85751682f87aa13bb6f5553ee747f78b81020d06d630"
    sha256 cellar: :any,                 x86_64_linux:      "27508ca2c9d6689a28f28a0e825d7e67f82dd9c07ead6705adbe25c1d5e9af98"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello.rhai").write <<~RHAI
      print("Hello world!");
    RHAI

    (testpath/"fib.rhai").write <<~RHAI
      const TARGET = 28;
      const REPEAT = 5;
      const ANSWER = 317_811;

      fn fib(n) {
        if n < 2 {
            n
        } else {
          fib(n-1) + fib(n-2)
        }
      }

      let result;

      for n in 0..REPEAT {
          result = fib(TARGET);
      }

      print(`Fibonacci number #${TARGET} = ${result}`);

      if result != ANSWER {
          print(`The answer is WRONG! Should be ${ANSWER}!`);
      }
    RHAI

    assert_match "Hello world!", shell_output("#{bin}/rhai-run hello.rhai").chomp
    assert_match "Fibonacci number #28 = 317811", shell_output("#{bin}/rhai-run fib.rhai").chomp
  end
end
