class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.4.tar.gz"
  sha256 "ec0d909a666d5d8319f86bf715036635d5ec9899bdb242d1eb3e2cbb4c04d2d2"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7640e12a9e743c6cced2680307d931ed577d85c5ea99a4e4ec1d1382c1c1b661" => :big_sur
    sha256 "c8f062c6832daa687f7049981d819415835bb553b05b903e2eaccfffd73969e7" => :catalina
    sha256 "d46ba5842e3bd3a38d1e471344097acc883641317255f1128015e5431038adf8" => :mojave
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
