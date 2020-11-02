class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.8.14.tar.gz"
  sha256 "8c1fb45a6ab0ac20b4131346f398d0f338db2697482c0b018026e1e584c79cea"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "069ea60cd5ce615c0d3a246fc2414b6c598e0e54f5f97c21caf8d18e06d67469" => :catalina
    sha256 "98230f38ff934584f30dd26843d3e8758b8241cc14131dd1a8e94cf376d438b4" => :mojave
    sha256 "d3d97d28e00d4f76df00ec322d144d47901abe0bcb5c9146b7e1a1b3bc1f6705" => :high_sierra
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
