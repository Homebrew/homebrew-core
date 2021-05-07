class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.20.tar.gz"
  sha256 "7eee04736afd409e85bc94d7dd9e82da3ea76aa658a17a46d00f07268d931d82"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50d8e8240ed70a03e63c9ba788801bfab6ee0e2b2c134e7a351dc8189c9697d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ae2ae1e0ea21a85e4bddb3d31d772513cfa033167833d76f27a69e6dae4847e"
    sha256 cellar: :any_skip_relocation, catalina:      "a0a7d9bf3ca5722927acb1c3456cc26bd6febf098ce1bc8616b25e4dfd466511"
    sha256 cellar: :any_skip_relocation, mojave:        "9104ae860f350569e6df33f4c3abc5a5f8d3b3749ed7f02cf0cd2d2e0bc703f5"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
