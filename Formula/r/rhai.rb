class Rhai < Formula
  desc "Embedded scripting language for Rust"
  homepage "https://rhai.rs/"
  url "https://github.com/rhaiscript/rhai/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "11b1303830b95efe153c8fcab25628b8304b31f4c2b8ecd0791979800db19e49"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rhaiscript/rhai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b13e0af55b0f0ff2c11db28b877fa24fb9b395df051a8cb406e3fbdb8c55439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc91dc8b4817eb2e12ee73a317e283deb4ce9e3cdb61e10ec5f440835e89546"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "007a9c01d4d28fb5f1890cbd50db8da29774dfb2166924f3bc46002eca043aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9e3530ec4b005d6b144c0869754d38f02fbe9f0e0c306684a4a5aac0389a1c"
    sha256 cellar: :any_skip_relocation, ventura:       "fd7252baec59a484b66ff70db31eec2c15ad6ec57230b014b3dfcf8d4aa45cb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1882578806acf50e157c2727d61e92a53c9b6d92ab7245e1639f72f412627fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625323d49d84a3cf9e0ea41a65b1d6d5b7bba882a55117da31e9b94bf0036a7b"
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
