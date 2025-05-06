class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "327e4672d5d7dc9b97acd9c7d1c2741de6bb11556a9311888a6aa48a7516fbb9"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc9911c3f4f63fd250b6a6b61bfc84d1e2e48b66b2bf4c35be5fb0b032142654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9911c3f4f63fd250b6a6b61bfc84d1e2e48b66b2bf4c35be5fb0b032142654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc9911c3f4f63fd250b6a6b61bfc84d1e2e48b66b2bf4c35be5fb0b032142654"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6eaa5881b31233ff61fca2b3e93a34823aa11be799487925cd74ed1301a8f2b"
    sha256 cellar: :any_skip_relocation, ventura:       "a6eaa5881b31233ff61fca2b3e93a34823aa11be799487925cd74ed1301a8f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacf5be4152076345fa85137a65c7487b82c42b7e9249d1dbf1760ba1c4a254d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
