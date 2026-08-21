class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://github.com/rhaiscript/rhai/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "5862084ee0c55882b58cdbb9fbee66a5817eac8f4ef16e76e56bcb98b486e03f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3815b45d329c4028b88735f9ca1724edcef83617513eabcb513b24fc54cf530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f7bc718144eb0319c8e8f581bf3ad747e6697563f9f168e07b6b82dae25acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b525ab1d4de6d08a19b8b3de149874be6c33fb5f96f39dc1c484eb616e0ad31c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d18017b6db42cf55a9db35e27fc8c14d2ec69e54f7dbeb4e400400ce55237f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e87cd4abd06d80495689ae2818f41cc76ea851da88417d811a64c2c796117e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af61f4eeb24a9f4e351047de095b77a483472602a7452cd0f9fb980d47823da"
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
