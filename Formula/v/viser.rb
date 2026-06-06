class Viser < Formula
  desc "Video Encoding Optimizer — per-content bitrate ladders from R-D analysis"
  homepage "https://github.com/vbasky/viser"
  url "https://github.com/vbasky/viser/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "f1633d2fb60918ade1fc1e94ac8ec28045165b07c9f241946ce7a22971068ad4"
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
