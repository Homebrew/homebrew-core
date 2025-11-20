class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v3.1.10.tar.gz"
  sha256 "11bf0ca8e10172ef2648c4aa4d711bec8a92424246dc2de1c3ccca44a76af167"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00984bcb15d5f440103a2e5624709609f1a805836de08fa7f79688b69052a78e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00984bcb15d5f440103a2e5624709609f1a805836de08fa7f79688b69052a78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00984bcb15d5f440103a2e5624709609f1a805836de08fa7f79688b69052a78e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf8e775d3cb58ec27606417ff63aefa957ece54cf5833932c2527bd8e5912f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48601489ace42402c8537ee487aa02dfc4cc0b11b3cbfbeab94f5ef9dd323273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5938f0666c48eb4ddcdd6ef37a82848c086b5400221ab989044a6912e833829"
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
