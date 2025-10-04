class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "27f89d4073a6b48e25197e128cafc202229d7a9d0205ff02de9f642a151f5f5e"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "277731e59a8ba000c231465e49c7f44bd6baa701763e8cfef685c3cb8375c937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277731e59a8ba000c231465e49c7f44bd6baa701763e8cfef685c3cb8375c937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277731e59a8ba000c231465e49c7f44bd6baa701763e8cfef685c3cb8375c937"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ab27b41939188e70664625a1c92067d98a85042e0e898f367e774c937d097c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7676bbac9a435922e3e7c5e4512b8e3c7ed238da92c47a0fb3293ccc43c5ff"
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
