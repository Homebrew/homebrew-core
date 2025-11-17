class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "b32500fed9776625602b083b25c9fe805883f916257b0c7e136f643936c169e2"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/vibecheck"
  end

  test do
    output = shell_output("#{bin}/vibecheck --version")
    assert_match version.to_s, output
  end
end
