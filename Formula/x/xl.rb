class Xl < Formula
  desc "Fast, terminal-based spreadsheet application written in Rust"
  homepage "https://rustxl.com"
  url "https://github.com/only-using-ai/rustxl/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8eb9a86fe86affe314392129d28c06894ae697da9dc8f3138e4796473ff2ae41"
  version "0.1.2"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "0.1.2", shell_output("#{bin}/xl --version")
  end
end