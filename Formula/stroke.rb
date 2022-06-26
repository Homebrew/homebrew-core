class Stroke < Formula
  desc "🖊️ A MacOS command stroke tool written in Rust 一款基于 Rust 实现的 Mac 命令行一笔画绘线工具"
  homepage "https://github.com/meloalright/stroke"
  url "https://github.com/meloalright/stroke/archive/refs/tags/0.1.5.tar.gz"
  sha256 "cd20d8647272dcedba5eb779e29a7eebe8ec21ec9e2947db893969052bc1aa7a"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "stroke 0.1.5", shell_output("#{bin}/stroke -V").split("\n").last
    assert_equal "stroke 0.1.5", shell_output("#{bin}/stroke -h").split("\n").first

    system "#{bin}/stroke", "0", "0", "30", "60", "70", "40", "120", "120", "--color", "c200e8"
    assert_predicate testpath/"output.png", :exist?
    assert_match(/121 x 121/, shell_output("file #{testpath}/output.png"))

    system "#{bin}/stroke", "0", "40", "120", "40", "20", "120", "60", "0",
      "100", "120", "0", "40", "60", "0", "120", "40", "100", "120", "20", "120", "0", "40", "--output", "mypath.png"
    assert_predicate testpath/"mypath.png", :exist?
    assert_match(/121 x 121/, shell_output("file #{testpath}/mypath.png"))

    system "#{bin}/stroke", "0", "0", "1", "1", "--output", "small.png"
    assert_predicate testpath/"small.png", :exist?
    assert_match(/2 x 2/, shell_output("file #{testpath}/small.png"))
  end
end
