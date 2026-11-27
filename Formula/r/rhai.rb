class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://static.crates.io/crates/rhai/rhai-1.27.0.crate"
  sha256 "c3925b784c0bee6542637e425ed7511a63257bf11b7ecf51ffd845e2d24d9163"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "7185db84e817a68bf6e642649d8e844dd601de0ab9de94971ae3b97d73101f7e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1abe4b3a611f6bd5dc408739b0e71d13263f3f7b1327e4e8a4f54b7da59c8a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "337684035438f1c490b7ac949ba0644676dad3da2bf91873087bce302beea1cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72f34da687a7bb61775dc4376e89e6e1813e9218688d9b942d06a758314e6788"
    sha256 cellar: :any,                 arm64_linux:       "7b8df198f6dab96c331bbbf021e9a74be8d4829d4560fbe906f23736a85fb422"
    sha256 cellar: :any,                 x86_64_linux:      "0013ac592d128ecac47ab28ddcb46414d0240f8aa180fb8e41accb3c02553598"
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
