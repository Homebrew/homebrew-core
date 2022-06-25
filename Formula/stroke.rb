class Stroke < Formula
  desc "🖊️ A MacOS command stroke tool written in Rust 一款基于 Rust 实现的 Mac 命令行一笔画绘线工具"
  homepage "https://github.com/meloalright/stroke"
  url "https://github.com/meloalright/stroke/archive/refs/tags/0.1.5.tar.gz"
  sha256 "cd20d8647272dcedba5eb779e29a7eebe8ec21ec9e2947db893969052bc1aa7a"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "stroke 0.1.5", shell_output("#{bin}/stroke -V").split("\n").last
  end
end
