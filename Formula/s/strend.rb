class Strend < Formula
  desc "Search and visualize Shodan historical data in the terminal"
  homepage "https://github.com/thoongnv/trends-rs"
  url "https://github.com/thoongnv/trends-rs/archive/0.2.1.tar.gz"
  sha256 "7b75ae29222344f674801d794f29c063971088c4cd50bfd2af74b562f1c6a98e"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/strend --version")
    assert_match "Error: Invalid arguments, please check: strend --help",
      shell_output("#{bin}/strend --query '' --facets os", 1)
  end
end
