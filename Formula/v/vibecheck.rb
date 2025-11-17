class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "827fb261dc8ad9069f1d9b2d1f61672711533d4e3f579a38af2b0a2fd8dd8bb9"
  license "MIT"

  depends_on "go" => :build

  def install
    # Build the CLI tool from ./cmd
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    # Offline-safe test: create temporary git repo
    system "git", "init"
    (testpath/"file.txt").write("hello")
    system "git", "add", "file.txt"

    # Check that `vibecheck models` prints the models header
    output = shell_output("#{bin}/vibecheck models 2>&1")
    assert_match "Available models", output
  end
end
