class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.6.tar.gz"
  sha256 "4e8390434586e4ab2eec65f0ef9a5af1be13014fe00d27a94f06151d703d8c1d"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a56fdc4e59440cd36f0225f721dc3f9eb003c201c2adaeaccdd0b3cb7fb1a016" => :big_sur
    sha256 "a1c85ab6586bc00477e6683c77b9527096f7bfdc78c7f9482ed83127c6e78bee" => :arm64_big_sur
    sha256 "58cdb481a8fc3c715617070588fad8fd4ebf392a882d872de3df7dea47b9a587" => :catalina
    sha256 "6f0e8fbb45323b4a0d894dac8bd52152740beb2477e8a80ddcca5b177eb4704f" => :mojave
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
