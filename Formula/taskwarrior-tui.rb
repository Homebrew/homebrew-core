class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.12.2.tar.gz"
  sha256 "db87db1d6757b3750f3deb3061295f29a74d325308bdc245f7e48714e1d5d501"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5b24a42e1a4b8db84c3fefd65a7ee11539a8fe2e7e0c914cf544797994e9dab"
    sha256 cellar: :any_skip_relocation, big_sur:       "132c8589c12db8fb140cca42ab9e9e096100c20c1659f369b9a2fc08b95f7d90"
    sha256 cellar: :any_skip_relocation, catalina:      "3fa5876a0669976d390b68643c7d74e42720d825f5d1dbcb85027bc802e1e1e2"
    sha256 cellar: :any_skip_relocation, mojave:        "9a5a0f08fa9671fdd3e977b4f69be13c88af6148207338e20e0769ae7ee412e9"
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
