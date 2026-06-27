class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "047985fc6a68ca1396cf54162e68bdb842b1177b3a25dc50d9d89e78533be836"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9cb3ed8b2b3ec050f2c55684dc2645466787643b6e482990839d18fb822565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f9cb3ed8b2b3ec050f2c55684dc2645466787643b6e482990839d18fb822565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9cb3ed8b2b3ec050f2c55684dc2645466787643b6e482990839d18fb822565"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7253c70220c4a94b2cce9036baa41239cc738012acdf1339ebed4b15a2c757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c424cd09d149fa0eb7403969932ee5611788fa47a6ce823f77f662c462b94e5f"
    sha256 cellar: :any,                 x86_64_linux:  "8f5537828aa911a2e9689232a511e5990628f2783335a5f26bb3352fb2f0f790"
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
