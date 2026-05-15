class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://github.com/rhaiscript/rhai/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "2256dc43858be79516e8975948aca7fd66977ba9c445376c00b24b4a289c1cf1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dafbfd966e8004e89388a1d6ee629ba86b63564708d91f911ef3209a9fe8ef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900d7908cb5a98e0fdb083865b75c41baf4059c19ababf5b0503dae26938e6ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48286583ce4b1d605a40f5ec820b0594f15e79f7125cbc8ce8351c4e2ff143cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ab902eafe2ba7b81e2e368871934e9a4d0ef3c1265ca6ce39a1c43773d119a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191e5a097a4cc235ee8d93ebf036b2d3acf70b6f01ffc5ee54def082d4be8bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20670022f9efad3e1004c54b5211335268a2465c53bed7fd00d31fdc39ab1312"
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
