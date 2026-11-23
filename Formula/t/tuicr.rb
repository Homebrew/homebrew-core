class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "90537d0823e8d55e1d81b6ee7742d65165cae8559d4e2aad566e2957ba53425c"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    manifest_sha256 "90419221bdb168d0d127ec8f30267b204a6f4c3336e8e1f606bb72e7b7ddfce7"
    sha256 cellar: :any, arm64_golden_gate: "ac6a5bd791fc2012f09c9188b823a306c9c65fefca0560e2373a5fb0e6b0ad45"
    sha256 cellar: :any, arm64_tahoe:       "d4edd1b068487aedf6d97656c5d894659635e6cce657609ee044e368101a9a00"
    sha256 cellar: :any, arm64_sequoia:     "4624ea2591a6516f53a31ad1bcd3a213a1e2e19994521ddf614b273d33716b59"
    sha256 cellar: :any, arm64_linux:       "e3da4a0e42b037d14909f51cfc5f3812ebe89d59bb335dc0d2f85262d3182d68"
    sha256 cellar: :any, x86_64_linux:      "68a0eae2d699b72b38550ef03b42bd051535643d4687da644b2ac6a08f6341bb"
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
