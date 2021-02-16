class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.10.3.tar.gz"
  sha256 "4c94e1f27465b72946d1c862c31b424323f6af1d56942d332f300dcde61fcf95"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fff399dc6e41f18e8369a0f9912c31348a7148d34586cb00e7eae4f88ef7ae8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "87f590412d3af642194f31d0a5234603a80f3ebc84b24f80c1130bcc5a22064e"
    sha256 cellar: :any_skip_relocation, catalina:      "3c4edc236b39b8a2ae4004a8c9037a4ea6ff20c65d4bcb17da6b137ae12ee719"
    sha256 cellar: :any_skip_relocation, mojave:        "91e7502289d2040be8e60f594be3a9a859dc58cada3bc0b43c7ab44959d4d37f"
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
