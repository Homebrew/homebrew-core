class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v2.5.15.tar.gz"
  sha256 "aba3f78ed6ac9150bfeaf1720398aaaec798ccc89e55a5df501d22c7218e3c69"
  license "GPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f47d8ce997a5acfcad30be790c52a82588bb290e83d0f6e704f6f7fbbe6271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f47d8ce997a5acfcad30be790c52a82588bb290e83d0f6e704f6f7fbbe6271"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34f47d8ce997a5acfcad30be790c52a82588bb290e83d0f6e704f6f7fbbe6271"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df38b2eb2f0d56d68ea6c17742a4cfdce6900bb715eabae8d018b2ea7e59b08"
    sha256 cellar: :any_skip_relocation, ventura:       "8df38b2eb2f0d56d68ea6c17742a4cfdce6900bb715eabae8d018b2ea7e59b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee86ab6527d4ea8a04611ea9b8c7f1241067702f035e6f5a93f7bc4e289651b"
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
