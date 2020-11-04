class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.3.tar.gz"
  sha256 "b6c24ee58efde1195c7ef9105450504da34cf67edca424e393d8a2f772f1ec45"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f2044efc86d463a6b4f595df446093fc606eb578b9aa0ec3716a0a3e112cd422" => :catalina
    sha256 "78e0711a52ba958b29d2b2c5ab74730d58d68134eec1d1cf65bcb1c82dbc4a53" => :mojave
    sha256 "7f3b4bb18e1c381b811e66462153e27f4640790f277b7d53912744257ec4c6df" => :high_sierra
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
