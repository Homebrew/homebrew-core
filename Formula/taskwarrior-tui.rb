class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.9.tar.gz"
  sha256 "32fbc516ea6843505eefa260d365a28e9554417c9385ab7da9336a9815197014"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2a5d47e8ac21dea6a4f905cae1993c6b99e92504c8774f9849f52ae6d723dfb"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4b1fad267ad313dd1d14f17c461e1aa6e2629c4a620ca0db1ac832d3f34bd9e"
    sha256 cellar: :any_skip_relocation, catalina:      "c2b56c50bad4706c4a87a1f8ad5521335db7e0c7cf93bc661e50354c0bfd513b"
    sha256 cellar: :any_skip_relocation, mojave:        "1a18156e6e87b93729fe42ed67b1dce3c354ae2417573af8c319ecd423fbe12f"
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
