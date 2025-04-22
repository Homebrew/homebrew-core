class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.14.0.tar.gz"
  sha256 "96d6d488f57215afbeb12b7b77f89b4463ab209cbfabf03e83e56908ff7ed233"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "747aeaf1466ec9ea0ac61457b76c4702a033d7d84e2bc5e19f692d7b978c5ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16715adf035972cf2170822a215f1e93f73bb29fc01f9d3e3791213475ecadde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d99ccc880724587eb2a50dbf9b33ab46a637de2b7da99fe1c1c802485728530"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b1a5311a47c795426b0bdbd50c420404d1a051d5e0d2284565cc61e29cb7abb"
    sha256 cellar: :any_skip_relocation, ventura:       "f79f3974f8391325727dc5ca5945f822bc36b1fc54bc3c7508be75133c79ba3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d3b0cc748c065e2553b36c7e8f9508aa9cade4c292894bcaa7fedb14aab558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550b44eec41fc7dd41f7d0357f1786480a4a389dec9af1687168d3fce29fc850"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rune-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rune-languageserver")
  end

  test do
    (testpath/"main.rn").write <<~EOS
      pub fn main() {
        println!("Hello, world!");
      }
    EOS

    assert_equal "Hello, world!", shell_output("#{bin/"rune"} run").strip
  end
end
