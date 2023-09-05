class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.12.4.tar.gz"
  sha256 "aa34ce91e2466e2d903d76c96e56cf01a82c689ea021b90c79df6dad96590454"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e13f897b15c3bbb9f17b1ef8c2d74b687f6df6b90d2af640d8a58de3bdbc37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c444f14c575c73c918a27cbf68147fa4647cd740ccf0fcc438b5ef9c5c3285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c6b284070b21d09deccc043db788db18756c4ab630fff7564f390baed1f6f99"
    sha256 cellar: :any_skip_relocation, ventura:        "7ab171a2edbdabe2c7f4a8f631d46afccec7896288c5315733a29ee7799b8264"
    sha256 cellar: :any_skip_relocation, monterey:       "ff521d35ebccad285d44adbe035b91015101a3e33cf9423f92af01e1c13a40c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cce90da9c198087768bc5f5e3c539e161ce1aa5c9d691569791ed5a850c5147e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e4369e6d3a6753db4393facaf77695909085ddb8791e8323048b7e51373cc22"
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
