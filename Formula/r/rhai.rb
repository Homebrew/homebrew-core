class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://github.com/rhaiscript/rhai/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "16c60ab5428e4ef1e4df55edb43914dd7f4fcee5615b3399b1a96aa2e9d9fe79"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09d1c838e78169868e40f03d2b17018cd044b1d780bc018f9136917275901af5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7208659b91f63561c5459260783a7e408b721304370a8d1cc063647e065b51ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e4a4cc3b640ffc4e8479f2161be68df4137915a6a3934fa41793baa3b83ccce"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2310e04362f3d57bc318482c04cc353a8cda29be8f959a90088ae377a6136fd"
    sha256 cellar: :any_skip_relocation, ventura:       "2f4c967e77eb0c6f9e70c6d8fc4a08903749c254cc04e64cb79220120a0f7544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df5a7cd30053615e06a8a97d27fd1f74cdbf3e2934009531cc396bc4f06ecf23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb590cb0d25f330d9b246d243df9b8bacab4439e52a54bb472bfc08ace2b963"
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
