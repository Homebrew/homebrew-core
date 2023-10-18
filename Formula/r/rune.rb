class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.13.1.tar.gz"
  sha256 "6916145178ec7dee6f1f9d5a555d15e406477f58904ed4a18df95739935cc668"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53ab01895f09882efdc9b2479563c02575431012a71d4bd8cab30733e9214bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a81277a22b2275dd82453a7a96425158966b1e55911543ce18c9b21160f0dfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f514c7a44aa58406c1667e054277fa7147e0188fa0d0aed3d20c64e8f9d1ed44"
    sha256 cellar: :any_skip_relocation, sonoma:         "e137951e6609ff7fe2ac67dfc6172f1b57e40ae545e240e542a8d57da199ce00"
    sha256 cellar: :any_skip_relocation, ventura:        "eca4ec10ebadf3155c228423eabee2b7223996b844e530f907cba04bf7823ff0"
    sha256 cellar: :any_skip_relocation, monterey:       "49281e873c0d3693af6a2c893fa3588f88a90e7805f534c81b617c8fc3cb7b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28bf5f61a0efa8624634ad17b853bff67a08292690452ad1b82428824bb007c6"
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
