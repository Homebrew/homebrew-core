class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.12.tar.gz"
  sha256 "012f9cfdfe23ccd428ff6590c35ad3e6d6f3c14d4a1259598bbddeb6796f70a6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7ee7839d0d31c937729983682c49d0a1faf7ef23817781bffba11e9a7029917"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c6b849c269e02400a5232e824118ff97bfedb2a852103ba6e81a7084f27fa69"
    sha256 cellar: :any_skip_relocation, catalina:      "2e3632f6337152ae2976295e4c21337d6fb128e65ad7c7e12eb2ec8840c4a3af"
    sha256 cellar: :any_skip_relocation, mojave:        "a02ba39d6e1d0e48c16025a71c08a7b814c6a260af9df826dda32c9de3a90c15"
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
