class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "72cc0250fa387480e3a32b735d5268c8cde3ee6401f8fb2e0d0639b01ebe2756"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8fb6eec690f3382e7d61d1594a67bb8b132c898c18fd55d6a2563032480aca55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cfe9b923e4b9b530ef7bd4fa9efb8c33a2674dc885f02edc3d2082ced80f6b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf39d58fbbdef4626eda0b9eaf397dfdc4087eb8a7dfbdce75b3a142bc2dfdbb"
    sha256 cellar: :any,                 arm64_linux:       "4135b319a26c46a898f7425ef179bcf3fed86210bbd774c2eea4158115f62617"
    sha256 cellar: :any,                 x86_64_linux:      "61deefaeb4af160ba752c21c87abe18c6888208e8bc0b37e3ec454f8b1c9533d"
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
