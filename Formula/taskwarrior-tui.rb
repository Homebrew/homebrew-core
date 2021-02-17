class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.10.4.tar.gz"
  sha256 "5e8ec1b0db8d8dd34e436fe1d0a3889b7330603a92f83e67f2615322e39dda9b"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52643530958f32cf8dc70c327f5eaf208d2b52c6d48ed98bc8c365d25d5909dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "fdc81822434b6dd200e2014cef43ec1d9e9274913f6173f54264bab2d501d422"
    sha256 cellar: :any_skip_relocation, catalina:      "d01f5383781bda0ae80c5cf5b9660f6b20057eed4db3fd3fcc42835f99b43147"
    sha256 cellar: :any_skip_relocation, mojave:        "b4ed12273042ded02e19ab4a080bdcdbf7e846cf242d78fba7bd9dfbfc5756f2"
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
