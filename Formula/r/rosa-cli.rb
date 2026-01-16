class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.60.tar.gz"
  sha256 "e0ef42391d233b28d89e7d19c43033c56b2490b6a766d78459085440f625404a"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ed7e45ea584e3b744cec309dcf77bfa295b2c47cc6275598389d699c7cff25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "161496acaa81edd21004f1b4a612e6cec22d1aa29f92856bac79400af72f2fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af62dd445869f229c0fce5dc89fe3662ce07ee9bcbcdac1239fb9b62f532aa18"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c06bd46b24094025b101edfa74dba1ecb30d52ed3746f0e12f80b78d762f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "177cf42db90ac2d12deb51bd094f747dfcb0fd7533b651290b36eebe209926d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938591c8d25beb8a01b518f18eec5e9e2ae00700c8b1cb388f8a44b1271b644d"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
