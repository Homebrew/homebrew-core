class Rotz < Formula
  desc "Fully cross platform dotfile manager and dev environment bootstrapper written in Rust."
  homepage "https://volllly.github.io/rotz/"
  url "https://github.com/volllly/rotz/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "b7556bdfbee63c9def84a6ce8b12fa41d3f7ee53e2d3b3f240d35110c9ed2f1b"
  license "MIT"
  head "https://github.com/volllly/rotz.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all-formats", *std_cargo_args
  end

  test do
    assert_match "rotz ${version}", shell_output("#{bin}/rotz -v")
  end
end
