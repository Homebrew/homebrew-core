class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.8.tar.gz"
  sha256 "3f6eac75252251d2757239a77f9ad0e0561e21aab8e592ce0d1f50e9bd0b8f03"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e10d3cf86f7cad557cfd770a9315e1fcf5d93546a26b8bd7f7c08a4e56af4152"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a7d564b139eaa44c44e29c7a3b7d89b83660520f1021b4c4a66d3cfcbdc296d"
    sha256 cellar: :any_skip_relocation, catalina:      "17f2c0c719283187cec2c1fc8fc5694542cb689aa9a735d3f5120f549e7b7f68"
    sha256 cellar: :any_skip_relocation, mojave:        "091af8a7cb43640439b32688ea6b7e8dbe5477d876f4adb0ea3323c549ff8566"
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
