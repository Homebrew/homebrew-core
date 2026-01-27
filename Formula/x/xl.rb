class Xl < Formula
  desc "Fast, terminal-based spreadsheet application written in Rust"
  homepage "https://rustxl.com"
  url "https://github.com/only-using-ai/rustxl/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "aabcf283f71b71ca15ddf2c23e2162b8c2dbd8c5cfa74200068910c349bcdd58"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "0.1.3", shell_output("#{bin}/xl --version")
  end
end
