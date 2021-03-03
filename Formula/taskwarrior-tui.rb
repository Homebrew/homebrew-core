class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.11.1.tar.gz"
  sha256 "51a50eb3799c38cd7310f63f282cb202344b6d2026ff139ec99c8f367ecc59ea"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "260c26575eda3e85f8dd2ffa4cfe1b8ea30c9426acce832043cf4524c60f89ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "509280ad70cfaecd71fc819b6fc7f03d98d8e5d09e932c4b04dc3e44b4617ea8"
    sha256 cellar: :any_skip_relocation, catalina:      "d109d6b8f35c38f44d5cf922c8e6e1ae2577bedb1f80e5b3395459958429e2b8"
    sha256 cellar: :any_skip_relocation, mojave:        "d61f0002ce3584fa2749598d36160e42ff31e3c548c5287d100e059b31e8955f"
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
