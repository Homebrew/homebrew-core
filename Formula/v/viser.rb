class Viser < Formula
  desc "Video Encoding Optimizer — per-content bitrate ladders from R-D analysis"
  homepage "https://github.com/vbasky/viser"
  url "https://github.com/vbasky/viser/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "058f1edbbf192b620bbd6c9b49a93399132b3afe3b01bc88fddf932821ff7bd9"
  license "MIT"

  depends_on "rust" => :build
  depends_on "fontconfig"

  def install
    system "cargo", "install",
      *std_cargo_args(path: "crates/viser-cli")
  end

  test do
    assert_match version.to_s,
      shell_output("\#{bin}/viser --version")
  end
end
