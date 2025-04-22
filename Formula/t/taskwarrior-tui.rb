class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "76f053e2e3c9e71b8106e3fc3c18fd4400a98c09a8cde5972305e0eeaecc08d3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7008f3327bebcfdae93a957ccad18327bb0b54fa10071fe7132af4d024d1f5bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f2155bbc016b0505c664d7725748fc8b4edf6fc0512a8a1b4aae89b9b152519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc2f0b120a04e533106d02ed25211ab53f16fd341b69697e21b5b9b814c92ccd"
    sha256 cellar: :any_skip_relocation, sonoma:        "77e6f2f4aa47b69eaca19366e84b61cc3cdd19bcab973ecbab047f07bf023d09"
    sha256 cellar: :any_skip_relocation, ventura:       "2706cbc52b513a724f58161361486e606acfa7bc52ebb0e9ef1ca9d5b659fcaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f7e7514a637880f4eca626c1187bc482f871ff107f7554e04198a6d7b2fbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac66f9b80b3d5fe8ebfbe7ff240f393c4ed76a088cd9e4ec404749e4e1b1b2a"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash" => "taskwarrior-tui"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
