class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.9.tar.gz"
  sha256 "8ea6c09fbd07cf8109d3c8e558b073f51689c4cfe021e21800bb14c58ec863bb"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1ab1b590ef5216b40d9a905f4329d33b07d23d2a8726afbcd8fffed8872df30"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdf2977545ecedbff3661d1995fac4df8acf60124ef8ab59af0ae39e101c28f5"
    sha256 cellar: :any_skip_relocation, catalina:      "b9f7eeea5f8036e959d5bf2b1384c2a3b969c364cb61199ab9d16ece62bb8fe9"
    sha256 cellar: :any_skip_relocation, mojave:        "ede876bda28c9866c13af458b799523c16718fb7bb5a926da693e21bba9c8a5b"
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
