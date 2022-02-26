class Wordle < Formula
  desc "Play wordle in command-line"
  homepage "https://git.hanabi.in/wordle-cli"
  url "https://git.hanabi.in/repos/wordle-cli.git",
    revision: "757ede5453457f58b5299fec0b6a0e79fbb27fa9",
    tag:      "v2.0.0"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    require "pty"
    master, slave = PTY.open
    read, write = IO.pipe
    spawn("wordle", in: read, out: slave)
    read.close
    slave.close
    foo = master.gets.strip
    write.close
    assert_equal foo, "Guess a 5-letter word.  You have 6 tries."
  end
end
