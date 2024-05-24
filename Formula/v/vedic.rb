class Vedic < Formula
  desc "vedic-lang is a Sanskrit programming language"
  homepage "https://vedic-lang.github.io/"
  url "https://github.com/vedic-lang/vedic/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "5453386fcebfa48a5f3d39bc832d19edaaaa98d8d36841428ff6a20db0dd0151"
  license "MIT"
  head "https://github.com/vedic-lang/vedic.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # hello world in vedic
    (testpath/"hello.ved").write <<~EOS
      वद("नमस्ते विश्व!");
    EOS

    assert_match "नमस्ते विश्व!", shell_output("#{bin}/vedic hello.ved")
  end
end

