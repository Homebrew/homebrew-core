class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "f56be997c91032c986fa7b9597ee1aaccc887321ea57a52503fb21d0ddb6c342"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc4f47269735a20ebed153e1c7ab13cee2a1206863d8ad9489c7ed7bfb84fd1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cc6d7aaf22aae10c3f9d9b9dceccb20d2da64cdd096fa18971f137eae8ab9e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0254e20077767b2d965da0596e5cca654cf4e4786c20c8969d1092ed0eb7bef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ac52e960821e2b3f8dd28abc4769e1708929a7f4bdf55915c059dc68540c40b"
    sha256 cellar: :any,                 x86_64_linux:      "4c213c55245fee47ad7479b09a0c0eaecebec84b6327dd56b89900a1bec3aacc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Homebrew manages upgrades, so compile out the self-update check
    inreplace "cmd/root.go", 'os.Getenv("TREEHOUSE_NO_UPDATE_CHECK")', '"1"'

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"treehouse", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end
