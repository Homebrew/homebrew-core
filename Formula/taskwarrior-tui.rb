class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.18.tar.gz"
  sha256 "3d1e5777d0112dfd0be4606a4d96022b10b1e8543ea8dc81436aa9d10a0a6ade"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4464d9fae27657040df8a1dfa240d5d693083239c1f1e9d38821a23dc4ca09dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5c9aea8b9afdc9aadf58ddacf922e75771ffb1680a083e1579182702f0c023f"
    sha256 cellar: :any_skip_relocation, catalina:      "16e42dd3ffe9c91e2181ecab514dc93fe9500d3eb4c3456d56e6d2c973e337fc"
    sha256 cellar: :any_skip_relocation, mojave:        "cdcb1b2ac16969d676e91ee69ab66bc8485af2092cbeed3419a4c7f7625140bb"
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
