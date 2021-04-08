class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.11.tar.gz"
  sha256 "d53ea3983320d552c4b3ae6b64774bdb0315e005e96cfbc46f4e41ef77116e1f"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b4c5810bee22c7a249f8b9df4c36e19fc8b0898aaa0be52657e031477b3f629"
    sha256 cellar: :any_skip_relocation, big_sur:       "8091586b2766be400649882b87ca2b9b6de158c1c0839cdf802f38eb040a3145"
    sha256 cellar: :any_skip_relocation, catalina:      "00ced09faf7352688b29f3d5ea0f7ae0a76b3f424177b05a3ae99df2773aa7cb"
    sha256 cellar: :any_skip_relocation, mojave:        "e0d890577d17d37cd00eeb5fe23af2b597548d2c7d9ef2e87a3eb9160e9d888c"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
