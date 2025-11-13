class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2c299bc1d1223220332c51cc1981324cef63889321eaa2c8a4644e9451232879"
  license "MIT"

  depends_on "go" => :build

  def install
    # Build from ./cmd as suggested by Homebrew maintainer
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    # Basic functionality test — must NOT require network or API keys

    # Create a dummy git repo
    system "git", "init"
    (testpath/"file.txt").write("hello")
    system "git", "add", "file.txt"

    # Run a safe command that works offline
    output = shell_output("#{bin}/vibecheck models 2>&1")

    # Assert that models help output is shown
    assert_match "Available models", output
  end
end
