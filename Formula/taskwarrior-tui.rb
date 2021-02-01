class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.7.tar.gz"
  sha256 "27b9469ad805ffe46cfede7a9c62342afc7d299a10b8b3fd992955cacfe29b5a"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "95b4a6f482d4e84377180e9266a60dac1679d1e6ab96aaad666d2cfc835a2025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f535bb2734877b0421b1bc836c7cad43cbe7bd81a75fcf5a53d16806389fbf6e"
    sha256 cellar: :any_skip_relocation, catalina: "d303e5dc711d59d5fb2207b5285267141be03ce4840239bbcba050d4541f2d45"
    sha256 cellar: :any_skip_relocation, mojave: "99c081e66ad8a5b8cd91e9c6b56b5d210adf1e4fa326a37d27b0aee9b1a93ae3"
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
