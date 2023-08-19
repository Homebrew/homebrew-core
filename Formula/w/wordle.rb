class Wordle < Formula
  desc "Play wordle in command-line"
  homepage "https://git.hanabi.in/wordle-cli"
  url "https://git.hanabi.in/repos/wordle-cli.git",
      tag:      "v2.0.0",
      revision: "757ede5453457f58b5299fec0b6a0e79fbb27fa9"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9db0e2f7b058f74ca8098312cdffa5d5cf60e5f9de7feb115e9eb43be2eb62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e488788ecd598f500999af6b5ea4f30a026302b1cd0378cfac67c92e361a8ee9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cb2a9a3f1a194601e659bc9ee54bca569c1a8a6d0915f2d93e6c00f2ba5d5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "8aa6128d0a94b33dfcb4551e0ed16cdfd5bcf092d7e9e823688b70a32fb7d307"
    sha256 cellar: :any_skip_relocation, monterey:       "629c70f19e09643f02fe8469d09431e2750f43035133195b048d55ce5538452a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d5f3906a8ae79361f3b872af994a0352156aa5ed63a85bbc879631c55e02935"
    sha256 cellar: :any_skip_relocation, catalina:       "4695e1205537e4f9838111d28acf5b00df5606511237ae271a278f6ab565a332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e3260ce269c6e96713e1b0d4f67b8111c7552293c3e37988b6bd59c0a8a6b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/wordle")
    prompt_first_line = stdout.readline
    striped_line = prompt_first_line.strip
    assert_equal striped_line, "Guess a 5-letter word.  You have 6 tries."
  end
end
