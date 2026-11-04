class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "28ab632f9d2dfef075e982fbbae8d018803174ea3ca81e4f72f51029fcd23399"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "116c23e3fd5fa50106ef2706f0a613e933e38bc8667261816d55689861177b21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c96aa0b6ae14afd9a20bd7e58d99e657ffb90d387307c43623af0fa08e1bedb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e29090703715bcad023a861a505a780f0a8fe0d6b42a5b52e6100ff2ac8bec0e"
    sha256 cellar: :any,                 arm64_linux:       "26b86849327a8c54f0dc380e44e5faf05e684d90c3f910894a5ffac3859e103c"
    sha256 cellar: :any,                 x86_64_linux:      "63b38bc664ebb3e7326d4de040aeafb05b51ef55e95ec5abcf7299de0d8ae6d5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tgrep-cli")
  end

  test do
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("hello trigram");
      }
    RUST
    (testpath/"src/lib.rs").write <<~RUST
      pub fn helper() -> u32 { 42 }
    RUST
    (testpath/"notes.txt").write "nothing to see here\n"

    system bin/"tgrep", "index", testpath

    matches = shell_output("#{bin}/tgrep 'hello trigram' #{testpath}")
    assert_match "src/main.rs", matches
    assert_match "hello trigram", matches

    assert_match version.to_s, shell_output("#{bin}/tgrep --version")
  end
end
