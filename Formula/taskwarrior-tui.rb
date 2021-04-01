class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.4.tar.gz"
  sha256 "acaf8ea75a74326c65f5be497461aea06fb5a532e8534213e4a1023dafd727f8"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0538fb6987d9b48e845e911fe52d1f99c4335fe940e86aa1a9f85792b1d0eb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "3936b8eae2388d4852461f5b3bd78a234bf9521f0ef97715fe78abec3ed61015"
    sha256 cellar: :any_skip_relocation, catalina:      "6690dc3ba9ec557b95684292934cedfbf7e40c6ddadb412a4eedaf542853946c"
    sha256 cellar: :any_skip_relocation, mojave:        "28ff19f6855facd090428f8c0b8a9b80c553dccc30a515037a19b64467750364"
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
