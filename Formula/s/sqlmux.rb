class Sqlmux < Formula
  desc "Terminal database client with tmux-style panes and Vim keybindings"
  homepage "https://github.com/kackerx/sqlmux"
  url "https://github.com/kackerx/sqlmux/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "49409df9a00fdbf9ca6b8951e8fb11a35070ad2c9456feea8de0870203eb1225"
  license "MIT"
  head "https://github.com/kackerx/sqlmux.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9b7db5242ab691b6decccf293c87385269f7c572ccf4a4373607fe78a841f97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9b7db5242ab691b6decccf293c87385269f7c572ccf4a4373607fe78a841f97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9b7db5242ab691b6decccf293c87385269f7c572ccf4a4373607fe78a841f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "636aa5ead40ae1df5198ad7cbeeaa0cd4df9dc54d70248908ac502458b2bbb6b"
    sha256 cellar: :any,                 x86_64_linux:      "7f23683de38d892f4979cadf2475cd47d98b0396b9abec1564ec76dde3b61636"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/sqlmux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlmux --version")

    output = shell_output("#{bin}/sqlmux --where 'id = 1' 2>&1", 1)
    assert_match "--where needs --table", output
  end
end
