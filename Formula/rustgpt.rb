class Rustgpt < Formula
  desc "Yet another command-line chat GPT frontend written in Rust"
  homepage "https://github.com/makischristou/rustgpt"
  url "https://github.com/MakisChristou/rustgpt/archive/refs/tags/0.1.2.tar.gz"
  sha256 "ab992767c69ba7532979693ebcc12076d1d1648b715e53569d1adba07919a3a4"
  license "GPL-3.0-or-later"
  head "https://github.com/makischristou/rustgpt.git", branch: "main"
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/rustgpt", "--version"
  end
end
