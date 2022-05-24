class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.10.3.tar.gz"
  sha256 "6a7154191b9f279bad68ac474107d9a24ff8470d3aca243c9805c2ea90534dbb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470720dc802a9d771b735348b6b70f99d0a7922884780b4d2d2331fb9cd36e0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dc6f0ac6d1c50d26dce9969acc9844fba4449f4a23e884a5f3dd371c5379c72"
    sha256 cellar: :any_skip_relocation, monterey:       "e5a6df8228e395fe4d5903aa7ffd1882df568f4f0d2e5c80f173bcd265d5de3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f06875e2bac0153db0f01ce2ba26e83a1383be95ee62dba2b68202c1c79f1cac"
    sha256 cellar: :any_skip_relocation, catalina:       "50012e39e8d7e32827c38e90ec51189e3d98ea92d16b534844a9e58630479197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49d1d808cda3a62096c5182f4c8a6b2607de99dc36ad9ec9b6e031dac995186"
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
    assert_match(/Hello, world!\n== \(\) \([\d.]+[µm]?s\)/,
                 shell_output("#{bin/"rune"} run #{testpath/"hello.rn"}").strip)
  end
end
