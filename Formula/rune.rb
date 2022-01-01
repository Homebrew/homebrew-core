class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.10.3.tar.gz"
  sha256 "6a7154191b9f279bad68ac474107d9a24ff8470d3aca243c9805c2ea90534dbb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

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
    assert_match(/Hello, world!\n== \(\) \([\d.]+[µm]?s\)/,
                 shell_output("#{bin/"rune"} run #{testpath/"hello.rn"}").strip)
  end
end
