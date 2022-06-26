class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.4.tar.gz"
  sha256 "a394994c545ddfc382b14e34b9d348d9df03caf906273b77b1f23c78e0928aa3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b96f20c184620df16e7c9a5c594a64d4ddbf6a77967de5f719ab61f8a1e5ab6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f830cb45bff81d92f31728686f9510f0b8e3ea1f56fd2e80b4f7a8737ab48c0"
    sha256 cellar: :any_skip_relocation, monterey:       "c45c8fe791f3dd97a832cba0303b3662c4923b6f7e5deafb7447b8d538f57cd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc7cebca0baf7e0d4ec9f9d04da6b808116cd55e9991e43aa89e5a191b198b9c"
    sha256 cellar: :any_skip_relocation, catalina:       "be4aa9a3f5aee31ba46d66c52533f61de4c2a0a79757f993e992bb7c0f7e6ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6a1176ffaacbf527eda62da7966dc3b170230836a8092db4a1448e749b2df3"
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
