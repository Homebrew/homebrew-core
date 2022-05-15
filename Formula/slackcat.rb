class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/bcicen/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.3.tar.gz"
  sha256 "2e3ed7ad5ab3075a8e80a6a0b08a8c52bb8e6e39f6ab03597f456278bfa7768b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f485580b0cf05cf5d7dc4efd6e6dc9aa29545d119ebc843b06d53c84b87f2f29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f765a9df06043f889342eb317e72648bc4904bea55d5339b69399b3a8b4ec3ff"
    sha256 cellar: :any_skip_relocation, monterey:       "e9441a1cadead32172fd7eb5ea6b4416ab09b7dffe04584394bad221ba0c0533"
    sha256 cellar: :any_skip_relocation, big_sur:        "176aa3f2c1f088a0dce065034c8a6d381830679db2425c4b4d690823e0b1e022"
    sha256 cellar: :any_skip_relocation, catalina:       "344233ded56abb6b28a5b4cde44cc58713a63e7a2b49a84b8c47c0ebc9d2d3f6"
    sha256 cellar: :any_skip_relocation, mojave:         "0aa9e136f18f6937cf156f00b850c37361a2f4616ea52783e471ded9de82ee7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96518aa5c2d2ddc1c62a1ee163748bc0909be294eebc290156a6ca1908d6216a"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
