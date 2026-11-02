class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.5.4.tar.gz"
  sha256 "ff51f589a7980a421df1caca3db6e784cb971b3a17997ecc60ff575b5e1742c9"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "730bb5f1c3e6056b17edafa8d9c2ff2db227862521291783245fe83839599074"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "730bb5f1c3e6056b17edafa8d9c2ff2db227862521291783245fe83839599074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "730bb5f1c3e6056b17edafa8d9c2ff2db227862521291783245fe83839599074"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a9efba1a2fd9b454ba84e3892824122db7632c8ce4bb35b1f7baec35dc29fd6"
    sha256 cellar: :any,                 x86_64_linux:      "8fb2c06f8fc3e9a67ac090b895aa24e01d2e020efd8545dcc43757df4172c053"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
