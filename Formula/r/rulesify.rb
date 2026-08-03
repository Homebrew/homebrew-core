class Rulesify < Formula
  desc "Discover and install AI agent skills"
  homepage "https://github.com/ydeng11/rulesify"
  url "https://github.com/ydeng11/rulesify/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e1931df3532e0d3434722faefe382e99cb3f4a85d2f05089be191191080542b5"
  license "MIT"
  head "https://github.com/ydeng11/rulesify.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--bin", "rulesify"
  end

  test do
    assert_match "rulesify", shell_output("#{bin}/rulesify --version")
  end
end
