class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.8.10.tar.gz"
  sha256 "965888e227bae667c6a12e096294d47b9bbf41a0b9561c0bc98e7cacb389e4e9"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1664e95647764000113f354ba0084ce2a4a168cba5a17a2ebe5dfd9d6eeccd99" => :catalina
    sha256 "a96ae6da5886cfb4747fc435c72eeda7d59494e93899935a0eb00acee220d39e" => :mojave
    sha256 "31d9b9190e9c03e33efb8de69cc539fd8930e976ceeaa3480a436e1bee160235" => :high_sierra
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
