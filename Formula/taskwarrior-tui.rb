class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.5.tar.gz"
  sha256 "db8ec8edec5283cbca0aa855238904fea570566e98d082c1121cd648572877bc"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc2653af2e5828ea6c05a4180ca02dee842cd67c598c4ade6e7a25081a41ef45"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d278c1a456294a7bc6026d9f1dca7d907286ffdf7eae75682af8a1648543a6f"
    sha256 cellar: :any_skip_relocation, catalina:      "ab3b7ba6a2bbfdb3c2edd00b70654df90684f44694fd93c5b64d39f133420efa"
    sha256 cellar: :any_skip_relocation, mojave:        "fc4ec0901e36c8f17ad8b6f64e55277fd114c4fa1ea0515579b0496d759f98a9"
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
