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
    sha256 cellar: :any_skip_relocation, big_sur: "d95511457d0951955d6fb3449e5a83dc3e8796458f7c6364c3eff174b7ae1495"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2dbe0d7946791d8ea3ea80e0527d3a20d71f90674127fbf6a25a5da2094c243"
    sha256 cellar: :any_skip_relocation, catalina: "aa3ea1277a5f876ebd96289acd20509d4c4f7fcdf458b2c8d92b5ba489451bd4"
    sha256 cellar: :any_skip_relocation, mojave: "7ac41be56caf327929115ab0b58142a594b3961758d43c20596d16fb475a67c3"
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
