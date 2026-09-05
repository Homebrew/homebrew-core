class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.65.tar.gz"
  sha256 "98a8c41c2bf28089afacf374deb0c9aef20c8e2651196c656d2bdb66572e14c9"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f518eb0a062dfd4c7972060e466c0383a1bba97d58d0904759310e51e9963b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef9fda09ffaa58099e389b79d29984586639dd806663d209c7d2d07c3199fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "751eac3a27d4e44f4fb1a2c940914df698bcdb7636225a1ca5d6113ce918eaae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e8c28f08327c384acb78885da265c879addd34756f9cc1ecf40c443dfaf27c7"
    sha256 cellar: :any,                 x86_64_linux:  "c5025e84940f1331c304724eb41223063066ae327185d59d0b0f46fb5b18b3f7"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    # FIXME: 1.2.65 was tagged without bumping `DefaultVersion`, so `rosa version` reports 1.2.64.
    # Re-enable the assertion below on the next bump.
    odie "Re-enable the `rosa version` assertion!" if version != "1.2.65"
    # assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
