class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.1",
      revision: "56a306c4fd0c0a88d7ff986724d5cf8e1af920b1"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b8bffc3f480bd53dfd54be6e5d80ff40eb88ae2d02fe67a1b9604e7c3d1a59f9" => :big_sur
    sha256 "bfc3ab319797126e880603726b81fd2655d6dbc739a1a3f3b99e886a1347ae4b" => :catalina
    sha256 "84fb97810a95d64a61bec2a49da0e2c8fddd9332978e1ccecd4b338d63044dd8" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
