class Wordle < Formula
  desc "Play wordle in command-line"
  homepage "https://git.hanabi.in/wordle-cli"
  url "https://git.hanabi.in/repos/wordle-cli.git", revision: "06f22bd2c41032901c514dfb74509392456fefe3", tag: "v1.0.0"
  license "AGPL-3.0-only"
  head "git.hanabi.in/repos/wordle-cli.git", tag: "v1.0.0", revision: "06f22bd2c41032901c514dfb74509392456fefe3"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    system "test", "-f", "#{bin}/wordle"
  end
end
