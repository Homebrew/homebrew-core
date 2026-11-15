class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "8e3d06161750b5d98ae6633de9cc47c0720fa86b6aa7afa7652b8aa3c6e85f7a"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cdc7ec595b6a669fcf30eac26af3d4070bad093578d3cf1f8f5e63ac652d358f"
    sha256 cellar: :any, arm64_tahoe:       "71648f1cf0822d1075c74a29af7c8367a7617ada5c93e149105505c1ab2bafba"
    sha256 cellar: :any, arm64_sequoia:     "9486acb5d23395f7f8c506d6efc98bf1b7a7a51a120e64c9f281bed0e5b8d753"
    sha256 cellar: :any, arm64_linux:       "6df7e0f44348215e11ba65c2a43d8b6d8b8150c7c94139f0f3661574a109a92a"
    sha256 cellar: :any, x86_64_linux:      "5f217954ca3c534b2fd89d56ecd74f5ad58d8c6bd7c64b14901e8fd0a90d63da"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
