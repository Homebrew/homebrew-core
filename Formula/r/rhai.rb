class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://static.crates.io/crates/rhai/rhai-1.27.0.crate"
  sha256 "c3925b784c0bee6542637e425ed7511a63257bf11b7ecf51ffd845e2d24d9163"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "543010de189b974c7ae67fd0e31b3b8b2016de36449bfd16a5a9e6148c166bb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54004377055f06a9411e4a2e6e9f032b884d5ed510401ad0c6e88957a68e427f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b5b014995c2cb48e78bb90834e87dcee4d2349955a1785f422cf582b63bb88c"
    sha256 cellar: :any,                 arm64_linux:       "7817f283fbf740098aa4c17e91c70191e349575fe30aa5db99b60e384e1152a1"
    sha256 cellar: :any,                 x86_64_linux:      "8c0a623f747ce0a96e89275c74b9a375993e3dc25b95590d82e9be8b1be8afd2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
