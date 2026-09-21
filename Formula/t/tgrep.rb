class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "3d3fe5ac5f2ea4d882eede95f70c7ab1a7e627fa81d5a80b2200dbcba4d6734a"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5394d6b991475cc43e62a8c09caa53c7b94203cfd144a3e3a8f3e9cfc17a0f66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47e722361c339a94be52da92f9fc49ff3b363058d4fa4d871bfbef47d23a82ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8fa1b9c39c786eac2f0d8aee5f1121bb8edddd100c45ca0aa105d4e5f6ee25a2"
    sha256 cellar: :any,                 arm64_linux:       "13771c4870abcfcc25c55a07b86cfb382276fabf2ae576c43edee5341afc6a55"
    sha256 cellar: :any,                 x86_64_linux:      "d8e4b66b67bd38f550de2456ef2aca316f98128f8afa710013ae56706e0fcf93"
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
