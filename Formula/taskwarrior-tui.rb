class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.15.tar.gz"
  sha256 "f9a3bec55c3adc948d4ee730477c9978f53c279bd48b086c344c2d0f8081ee39"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "677544fdb23b8aa9ceddaa0c4897dd20855d48d51eb97fab8008633c2d3d26c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "f071756472d8c383b44253832f96bcd113cd99aa827af94ff49735d2ca9901bc"
    sha256 cellar: :any_skip_relocation, catalina:      "1232da01d6f75aac6ccf50303965bf4f3a203126a2f86a5dc24f1504567ea677"
    sha256 cellar: :any_skip_relocation, mojave:        "057cac5a91106113b7a498ac8a8babecaef85514bb019505a6076d402287b1fb"
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
