class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.3.tar.gz"
  sha256 "cd1bd532301b6ef3f763ef5a2bc6fbc20a2fd5cefa1f5dd71b3bbc5e4f688a75"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "076989c8019a75fc8e3201864f0a2a71ed8f577c51f4df16daa97e715cb06cdf"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b94346cb1f01f769783da10ec36dbbef40dcfed78cc2d1840da91c2da16d2a7"
    sha256 cellar: :any_skip_relocation, catalina:      "4e165b1f2d4265752a2345b0d30ad6419b938249edb256cb74e44df30055cf79"
    sha256 cellar: :any_skip_relocation, mojave:        "4d054ca38f5ea957d613d806009f8ac29f5bdbeaf5e57bed699a27e9297f2323"
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
