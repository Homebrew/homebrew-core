class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.21.1.tar.gz"
  sha256 "1c778c3592b62f88225f2ccba128b1d84e80ca61bbe287c954d34190daa5efe6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d362ab4e7749a86a20a73bbc34edc34fbfa1ab44bc805ff85752761d74be8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "697846e8e9427628f09d72d016af175062ac77fa85ede163a8174175327e8ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "ba317b568e4aedf19870431da5fb264bbea1c307e2462806b57de0075738bc46"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d55a3acd809354aa55008f323a20bfdb9b6a1f3e4b3aceca5c728376c475912"
    sha256 cellar: :any_skip_relocation, catalina:       "20728bf5a6ea21dace1859c0becce7d4074d5fc83100e82b4f0e518fc9efde38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60465b50a95b209a8147d466b6422ac0bf07a2382caec61b40b6737a9b14fb3"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
