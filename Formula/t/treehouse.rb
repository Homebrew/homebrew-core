class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "6b1585861e7e13d2c4bd4bcc3006cc2450ace13acb51177e4327e544bdbaa90a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03d451267356a38275df60567c5b8aeacf21de848aec05893de994766e20a089"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51587bac743fe37edf8cf82c57185d3db03328339fab7ea312dd2611e7e0ae30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef6473d5578a0c76ef1a36ce4eb83f7ff538b22a3889eb2506e6c381eaf3ff50"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8bd551be495d32736d7c2a111d22f36057204b7197432d0ae0683e0f75254769"
    sha256 cellar: :any,                 x86_64_linux:      "9d2732880fd2351babe8adc09d785e109023308d209c2ab34fb1ef0907ad8392"
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
