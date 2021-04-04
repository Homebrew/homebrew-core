class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.6.tar.gz"
  sha256 "0bf5cbccc5192f0c1dc3824e9634024a9123e346c1f5b45231c81745328b38f4"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "963a4080b3220b3e68f6ee730eeae7a70eadef336712b5f4588475f19adb796b"
    sha256 cellar: :any_skip_relocation, big_sur:       "31ad69c7a823c2ea910f0eaea865afb8216156c50e2f696d189db169bf08448f"
    sha256 cellar: :any_skip_relocation, catalina:      "58cda012a9626bfd493928ce69606cb3f987df08414a7dd2159129c5d5bb6359"
    sha256 cellar: :any_skip_relocation, mojave:        "27c3d17918e69d0881bd98e8be0527032632be70a93bb97c136ad84092bd929d"
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
