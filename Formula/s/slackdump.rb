class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "494c3b5efbb4e37d427bcdf15dc946b09e5fd5d13ddf17373ca216a14df8c27b"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98817070bccc778be83e88546235f312786ce0e61dc05bd8115e7eac20f5902c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98817070bccc778be83e88546235f312786ce0e61dc05bd8115e7eac20f5902c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98817070bccc778be83e88546235f312786ce0e61dc05bd8115e7eac20f5902c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f08235aac56227e8363e5c4929913b1632d34975c6d4505763893693e1708f"
    sha256 cellar: :any_skip_relocation, ventura:       "f5f08235aac56227e8363e5c4929913b1632d34975c6d4505763893693e1708f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d643ebc5d710565cc84ef3ef7ca4fcb369a87c8318eb10a9ad99942e024245e"
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
