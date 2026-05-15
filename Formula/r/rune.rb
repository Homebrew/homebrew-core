class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.14.0.tar.gz"
  sha256 "96d6d488f57215afbeb12b7b77f89b4463ab209cbfabf03e83e56908ff7ed233"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e5d320cbbbb7e69af88b3336419fef1300f6533d3cf0681446bd4dc5fc115b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcb56c53e49fea08a2ec6af57dae05a0a619238ee74d81d232c3cc154ffdae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f234fd924889af3d16deeb4db3531f0fe978f82c971ba6d0e9f995f0e800a5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d746cfbab04df2582234d67eca27d2a6be15b5a9c31c391a6a775448193844e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b2583e54c1bd7da75aabea5b82e2247ae45648a4256621852f22dbbee5d81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28dcbc87969e792495a32fdd21f244ec98eaf4f145ffa9b315143c98161a843"
  end

  depends_on "rust" => :build

  # Fix build with Rust 1.89
  patch do
    url "https://github.com/rune-rs/rune/commit/6594f08038c3474de6e6e3b215a15c3940f71473.patch?full_index=1"
    sha256 "8fcd1f04856df66883975fcbcf7aa8e36607d258049fd2e57991c27e2542cf9c"
  end
  patch do
    url "https://github.com/rune-rs/rune/commit/f49ba15e62589025eba7fa3e01cccd9842c7acee.patch?full_index=1"
    sha256 "e8d34a1c4c476c5cc56ecf0f925db23f2c29a9a48fb6fd1b039dd28057ca9fe6"
  end

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
