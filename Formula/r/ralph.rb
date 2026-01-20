class Ralph < Formula
  desc "Autonomous AI agent loop using Claude Code"
  homepage "https://github.com/kcirtapfromspace/ralph-machineo"
  url "https://github.com/kcirtapfromspace/ralph-machineo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "363d0e06c6dc4a6609423ad095db8d0f5a848ccc3daaa42fc10b9c2762bd8c9c"
  license "MIT"
  head "https://github.com/kcirtapfromspace/ralph-machineo.git", branch: "main"

  depends_on "rust" => :build
  depends_on "jq"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"
    assert_match "RALPH", shell_output("#{bin}/ralph --version --no-color")
  end
end
