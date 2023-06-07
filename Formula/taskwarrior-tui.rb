class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.24.2.tar.gz"
  sha256 "6f567acd8f0ba6009f20d9ba60078e2b999fddb0fdbcffa75f088c62679b2dc3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bb724a39ea548915f90bd75f44b84951434057ca6e90cde4e79c3800a80d12c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984eb769c798c0ba5848d1a9180d6e84850186fdc3bc0ec0a0ff77274eb9a267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9271a0a1ffc049eb824d0d11ae9d31ad75328bc8ff0c814c1a0a630665fdd9df"
    sha256 cellar: :any_skip_relocation, ventura:        "854de7813453d429e70593aa7ca52ea24824bfe828d0aaa5e08985db69c6e9c3"
    sha256 cellar: :any_skip_relocation, monterey:       "02b81d12645c31a3928a63b0600a4327b555e53c9cf5be06484db68cecd6e649"
    sha256 cellar: :any_skip_relocation, big_sur:        "81c98443e06b7a1f0c99eaad5944c628250082e1876c08e22011b7c2bbd5ad27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8b9bfedee5479a96bb4456d083ed1cb51c8c97bde8461a09294963b1750d92"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
