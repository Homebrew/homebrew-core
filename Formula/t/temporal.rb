class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "eada525bab531952b84bd78ba9631e1eaed64eba9860fd61ea1e874d454e6d30"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d9ff5ce41efae116a0ac83b83a6e214300e17115296862cc496b0de9d42ac06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33040335106d982019391b38a8c04945a45b0877f95fae8ebde5374dec025e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd70a82c2253c511af8d0b859306ab807f17f1cc41e12aa6d597de7285a15dc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "680848fd9e896df9e97526ca17823b3da40833a3c9e260d8088d59a69dacef79"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d0ab449b2529ff78236fb48fb16aa66d527a371c9d445294f1f870e958ec55"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0cb7087bd7caad4f6a3be9ed127684f123e463a90a5ddb09bf91be6193f279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e504c01d06115298129ec7eeeb5250218b07378cb75748287dd6710a3140f04"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable bin/"temporal", "completion"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
