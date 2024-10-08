class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v2.5.14.tar.gz"
  sha256 "81319c48fa5e202a873792ff772158a0fad6634236a0ebbce945d0bda988fd72"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea21bc348d036d8cd01a02271c36cd05383a90e5cd57b499623e55145e560a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cea21bc348d036d8cd01a02271c36cd05383a90e5cd57b499623e55145e560a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cea21bc348d036d8cd01a02271c36cd05383a90e5cd57b499623e55145e560a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f9328f808e67c2afc3b00d800d5d32cab95fbec7c3637eed8d23bc750597fc6"
    sha256 cellar: :any_skip_relocation, ventura:       "3f9328f808e67c2afc3b00d800d5d32cab95fbec7c3637eed8d23bc750597fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf644f38d6c0410ea6cb059ee72b43da9986fe4326e364106be27b3ebb9d6521"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output(bin/"slackdump -V")

    assert_match "You have been logged out.", shell_output(bin/"slackdump -auth-reset 2>&1")
  end
end
