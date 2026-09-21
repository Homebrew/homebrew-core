class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "2ab1e5989b3f5a8b4a1b82734f69da367b45a68cd033edee02131fbf0642a802"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1471b39dae122d26ef8730b891c86caafc32f071de096b92f3576765d0cc655f"
    sha256 cellar: :any, arm64_tahoe:       "657f205dc54bb4e449dc2594e05a6c4fdc7a358874b9f989576c055cd024347a"
    sha256 cellar: :any, arm64_sequoia:     "03995df77438441d630bf7b478b185d84fd032442309a491255bd780906848a2"
    sha256 cellar: :any, arm64_linux:       "1611c619c9c56f65b96825d0f31bb6eb1874126f96a99f5efb2f481a9318e46b"
    sha256 cellar: :any, x86_64_linux:      "f0327af0f6a6aca6c83272276fe985285e917d4da48777b642fc0a8e7485a578"
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
