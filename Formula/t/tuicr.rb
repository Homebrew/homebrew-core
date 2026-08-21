class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "2b0f28b6f15f8fae94a6c823c14667dad1828565ccb04d95ad84957cd548a3ac"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fda87fec45ea90bb0117640862ef87ee5d9b1ab7bcbd0a1cac5c69cf65ef0786"
    sha256 cellar: :any, arm64_sequoia: "7888e70fe262ab3e78ed9ffef3d05c53b1614c6bc9e8083dbc826a92ea749ef6"
    sha256 cellar: :any, arm64_sonoma:  "e02d2e7d32baf390d30b6584898a8eada59f2cc67bfd57e13c0e248a35a0f874"
    sha256 cellar: :any, sonoma:        "307865bc57a73277243251a7cc1799a7dedabab2c0f9c9c6610f3677c759073d"
    sha256 cellar: :any, arm64_linux:   "045ab5b05d6c5b62c85bf29aeb15a34ede4afceb4c284ad02a4ad32a35d07a27"
    sha256 cellar: :any, x86_64_linux:  "642f34036856337f9369cbbc718712a00d7b8876d1be2397bab27f76ce9bada7"
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
