class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "2ab1e5989b3f5a8b4a1b82734f69da367b45a68cd033edee02131fbf0642a802"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eb9383cde71388d87fb149382eb4091893ce10ae0d9a1d9c493b015e0d718d7c"
    sha256 cellar: :any, arm64_tahoe:       "d6248867ad4e83f5adca328819cd88248107e874081e984e37972bab1a978d97"
    sha256 cellar: :any, arm64_sequoia:     "847dd95fea49500baf6924ed809592c87290c660fa28252416a34af76d893d84"
    sha256 cellar: :any, arm64_sonoma:      "fbf743e8f5da7883bf75e5249a7cc5eae47e182c26221316fccd7238385856fd"
    sha256 cellar: :any, arm64_linux:       "6afe55a819eab05e9d73594f7865c4a0394349c79f685e3d56ae0308e1c76e57"
    sha256 cellar: :any, x86_64_linux:      "266c5563a85baa5677cde3597550691ddd14cd129ca4c23ef19243000830987e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "test"
    system "git", "config", "user.email", "test@example.com"
    (testpath/"test.txt").write("hello world\n")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"

    assert_equal "[]\n", shell_output("#{bin}/tuicr review list --all")
  end
end
