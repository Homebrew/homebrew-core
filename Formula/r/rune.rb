class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.14.2.tar.gz"
  sha256 "a858800d066f47e101c9b613d04dbc3f3d6d2bdb932da92f37c1ccdc79077337"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bcfa3336da95437b8ac858a9598d860cd08759a92db8c81c554c5a2b3f38cf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d42eca1ecb8b5df3ae6407f385603912939fa83bfd314dafa0add95962e316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bbb003b255dc56d0037663880720f31b4b4006263a8ab7c3b1ee0cf345a88ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "34ff0d5ba5da8f1d6fdc92586e5b788ad24c859d1ed35c656ccd07b1fd653285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3946e2c79aa6923a434122b281425b18f10261543c1dc1353d4ef13c88b369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c9b6745f20e22d0fce53c3ada2a64a86bd29ce0085bcedd2558137dde29e9e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rune-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rune-languageserver")
  end

  test do
    (testpath/"main.rn").write <<~RN
      pub fn main() {
        println!("Hello, world!");
      }
    RN

    assert_equal "Hello, world!", shell_output("#{bin/"rune"} run").strip
  end
end
