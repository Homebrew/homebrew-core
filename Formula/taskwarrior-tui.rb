class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.7.tar.gz"
  sha256 "9e7dbd61219a0a7cc1916c71d05b778e515fb4eff5a22c523e4efb3ff826f4cb"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3d68c380a72c31231911fc7dcbd0ccd2f56b6196b981f9af78462a70f96cbd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fe9012e89396abdc227050c9d4a35a2de4e054364e01f4ad757599f0bf948e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ebcfe7a41799f7a44a0c39504af448d97940907e223c2194d3ed92c72f8c94"
    sha256 cellar: :any_skip_relocation, ventura:        "76632393f6d8278ae843e8e2c1d6fd797cb75af228f81600293abd237af0d9bf"
    sha256 cellar: :any_skip_relocation, monterey:       "3448229cd7997426d3338c653e854f24b783eeec113c076c2da7530e1c6d2298"
    sha256 cellar: :any_skip_relocation, big_sur:        "a26f4c2de53689ae9c6fcc2c3fe5ebf92a2f726bce63f32960592e4a74a534ae"
    sha256 cellar: :any_skip_relocation, catalina:       "8b749d8131f6fdcc130943c845d5b06a2a16defa1dfb9c69f4095eb20846c2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6c7b7469e4a9e98f3735b62a2d188cf3ef63f43f82d262a28289d2a017725f"
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
