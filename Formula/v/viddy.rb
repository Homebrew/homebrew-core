class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "59d5be862cf6b522ed069e276c28f927e5d2cea13525513959e1577a5ad6afd5"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7c01377ce6dc8d3cef31fa0ffefa6dcb6e2b3f0c4edc0519f937a0bf4e96a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618af16f6d99f7f2309e65cc33b60eea874f15ae8a0965b873c1a8ef1f9bda41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9475b43a3238107af27cd6d6f14621af0e5e0fd0504a3fddad1e33277f3b7af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5132a22bfe77049378f62158a9c2fb9e52ab6f04c426e9cfdff4e7c78a0de06f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a635acfdd97d4fb6f785a0164db30c399430f156b8012b85ad82a3872f39b869"
    sha256 cellar: :any_skip_relocation, ventura:       "81a7bf5985de9f5702b68665dfa75f562819d363b5d6a4c882c5ef9b778ed18d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f3f38348b9fd1683ec0e625e899e8254fd6a7d1f54d2f0e7d3b09dd887aca16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2936c3ac0cc4092280d63ccc8ef986cfaad49c117fc763266ae435edaa1626e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin/"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}/viddy --version")
  end
end
