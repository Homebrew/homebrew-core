class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.5.tar.gz"
  sha256 "1e31623a1b372c5cfa628fadb45c5c4d6e7bee3ca17959d923f28651ba1040e8"
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
