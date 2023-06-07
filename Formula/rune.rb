class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.12.3.tar.gz"
  sha256 "c99a8f94fb763d63ebaef0a1b4b0009e88d1fee988a2d1b0448c2821e4d63f37"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "881b356d01b4883276f282259618c1f9b6896a5be19c4b0751d62cec55e8335f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ffdbb1cee46ecc96ce61efb44146dc9b29dd87e50180f164206bae0d7e1517e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5647a32d89a6070d6f87125b4d362d2c14c985d60137d1671706a3e45233e86"
    sha256 cellar: :any_skip_relocation, ventura:        "394291995a28357fd370425a8ab7688452f38ac07ec80c9f1946c1a25c38a9b8"
    sha256 cellar: :any_skip_relocation, monterey:       "86596cd8c5f11cb27e6be609c5193cba88603dfd3631c87bcee7c3720e16afb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "956370d1058e651f6da749159f8bf201a44032cd9bbab991184f9bad32b1ca29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8097fb9e0b85e2e4d1e86d517c89af9c8ef85ea2ebbfd045cd909a987ae730cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rune-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rune-languageserver")
  end

  test do
    (testpath/"hello.rn").write <<~EOS
      pub fn main() {
        println!("Hello, world!");
      }
    EOS
    assert_match "Hello, world!", shell_output("#{bin/"rune"} run #{testpath/"hello.rn"}").strip
  end
end
