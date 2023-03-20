class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.12.1.tar.gz"
  sha256 "c4ae62619005fa212d8fd6a6496662dd1b7bfabbd1fa1aae06e86822af585ed3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffa6a8c977391a2c3c5fdceb44471c90e22b80fe9a0132b8bec4ebce7a70cf22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34c68307b9092b6e3f1b12f18cb055ec446fc09d1a4e511367503f083ffdc18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89217ed350fa8cb778068f58f2ff08e2b1e772d18296eb83a8ca59f43d8e71b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9c72b883471f161dea927c37be0d3da38c1e64de40499ec6e7fb961130a84baf"
    sha256 cellar: :any_skip_relocation, monterey:       "bed0aa7434c41964ffc8dba0be0a6ec86d392bea94da88a596be2c2f2c97b281"
    sha256 cellar: :any_skip_relocation, big_sur:        "65c79d43989b59b09435d7a4c75941920b73e743824905f83b67d54d26cdd55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701a52ff116a12bc1db99aff71f0894facd48b7aa086c3a9fc9dc20a7d816ee6"
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
