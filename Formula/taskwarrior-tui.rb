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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e08ffe40c93a36f0412330e3fff4dfa0ae73cf320a531cc2956d0a24f074492a"
    sha256 cellar: :any_skip_relocation, big_sur:       "75a9f355a759e4b0fde120c5b34e7f3855b5ddc049bbe0f00ac1b0e6cb9b00bb"
    sha256 cellar: :any_skip_relocation, catalina:      "6b7bda4c98351483ab6f775b783f6afc3fca51b85775a661b17ef5791aa693cb"
    sha256 cellar: :any_skip_relocation, mojave:        "421b464f1e8467a9084d553d2353ec3070afa305b57fcfb771dc6c74abab47c6"
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
