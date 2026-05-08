class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.62.tar.gz"
  sha256 "02f794a97109b76bf2952989be533ac7ae5e2b1adf3cb0cec66d23b8ddab9bf4"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d456d966da56920de6f62e8a48626a131655abccb314dd6dd93e06d2192365"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9e160495866b537bf7f2ccd0f608c517d32d3b8a11ae3a09da2232f3b95b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a6d54ef6741627605ab8c67cbbad4f5b563d4f08656bd8c62b295f3352edd87"
    sha256 cellar: :any_skip_relocation, sonoma:        "a07c8d42e85e454c7d8b0f1bc78ee4cc4393dd4fba0af35041907080452f980c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b25c588fde78f94b6dcba10b0b0243646f8c225614242fa8df68db28abc5a61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f4c23cc10f5c52b7d81f2c12446b71147e2f18278fb7418d61e4534bfc06ac"
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
