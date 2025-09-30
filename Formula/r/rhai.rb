class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://github.com/rhaiscript/rhai/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "11220505d2cd1882da22a40496f2d0f92d7a1842495b20e2750f2a4cfec1d9a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96ea3c25d9d2c9c6e400c012645a5b06152d8656e0bd972dc0a2231908ca13d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80852186b6b3fc7bb631db5b5fe814c3b1345a91e13020181e75daf53fc835b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d0906bc975a61a568067cb4b95a3a736752e5e8144ddb458cdcfd34d83ba491"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fcd1a23c0a8af5c95092cb9b19e62a4758f6acdb580a4fbea860be2bc8800d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f7370d40895a83377bc3e4ad4bda93f8eb551f25f774ea24beb8abd294695a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc9cc7a047b97ceea9558251fee84426ead680198600d6213ae07debd510e51"
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
