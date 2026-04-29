class UuidCli < Formula
  desc "Small CLI to generate UUID values"
  homepage "https://github.com/uuid-cli/uuid-cli"
  url "https://github.com/uuid-cli/uuid-cli/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c20d00873c0d0c43383b993f73bfb3f11683bf5dc1b606d2156336077e856737"
  license "MIT"
  head "https://github.com/uuid-cli/uuid-cli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    output = shell_output("#{bin}/uuid-cli --count 1")
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, output.strip)
  end
end
