class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.10.2.tar.gz"
  sha256 "9a38402770d4f71124e2ca8220d5e2c4bca87701792862b7085ce7ffb99ea88f"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e08d02eb10a7cc230add400f0343bdf4392844cc67897cd785084a2e4bd8492c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d79a9c2040febe2053977fb886d92376bb931899ea57b5d7b2ce1ba8ff9bd32"
    sha256 cellar: :any_skip_relocation, catalina:      "334dd59bad241e86ae58dde06097122ea04c55fe6ca7fc110be864583cda3625"
    sha256 cellar: :any_skip_relocation, mojave:        "c3ab5d5d216088f3f1835f5ec5cdeb06be2c157e8fe2a8834f8034792c7a0a5e"
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
