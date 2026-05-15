class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "9e07c1d7c606e7cc6f404f1174aa85bd4c569dd94f67ad7b5c2435163f28dcf4"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcec810c1ef662ce6ec7cfce4af3b6cd4f217806f0cf60efe23ddead835d59c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcec810c1ef662ce6ec7cfce4af3b6cd4f217806f0cf60efe23ddead835d59c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcec810c1ef662ce6ec7cfce4af3b6cd4f217806f0cf60efe23ddead835d59c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "90bf5a6df7fce370d9d328842eff3a1b8bb6fdfac6fea961ce4218f0030264da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f9d1624bbadbffa0f1db318bd342cdcbe23597bc334a64ab0c92ab6b0e183eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da61906cff4d0f956baaf575ef7769599026e74c52c9ad9ca5a0a9985c46584d"
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
