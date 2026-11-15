class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "28ab632f9d2dfef075e982fbbae8d018803174ea3ca81e4f72f51029fcd23399"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b58b353b2d51ccaed5782326567ac6e6368d959c9f6cc0078782fad072b1264"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d46c08e56b5b4c303c1d7b9b2ac9fe99aaa3249d21afd3305268d05ac8fcf31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "301f31e7deae4724977c8348f17971ccc02e91777d906635ef6e1049ba0f070e"
    sha256 cellar: :any,                 arm64_linux:       "5971e02baef54a0d39b1ab72c65837882d40ff1f2f3a4b7c7c8534afd3b3a8db"
    sha256 cellar: :any,                 x86_64_linux:      "17465c5e1c461e705780c1e20c7a91e8a4860be5b1e3dfc5fed107e41c54c0bc"
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
