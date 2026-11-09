class Sqlmux < Formula
  desc "Terminal database client with tmux-style panes and Vim keybindings"
  homepage "https://github.com/kackerx/sqlmux"
  url "https://github.com/kackerx/sqlmux/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "58ee19faa767394e1941d181602191d0b76d618463ade6d0959924c06d9b7c67"
  license "MIT"
  head "https://github.com/kackerx/sqlmux.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8693d64e956f3d71b780a88562104205be70d3bf8d0a5dfb5e642d924e91eee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8693d64e956f3d71b780a88562104205be70d3bf8d0a5dfb5e642d924e91eee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8693d64e956f3d71b780a88562104205be70d3bf8d0a5dfb5e642d924e91eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "821184f9f1c405705e61cffd02c95e0d2de904ae8d40e7129e99f8c852e44698"
    sha256 cellar: :any,                 x86_64_linux:      "d9b8904c2aadae5cdcf30fabfbcd30c2934ca086be7f699006c9f1e0ac3fb12d"
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
