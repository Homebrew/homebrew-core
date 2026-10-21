class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.66.tar.gz"
  sha256 "87098967360fea1e6fcdb3703f1cf6034ca00c57d12e79a97d69bfe5594433a8"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0527e073076f82a7f414720ad7bb2bacc2ed6fb33c937d32c665a75336997e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3db35dca1087502a64baec8a6a1b5a83ea85fb85c166443aef94bc3f3ee64094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "906b6100b90893b04346915077c51424f1590327aa94d83fc62383388c5502bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa792bd13890c5868c14ee1126b3caebb0496fca8df1b3926941001792d7a3d4"
    sha256 cellar: :any,                 x86_64_linux:      "9a5743cff6d2c14383fcd1b8e3103dc1425b2fd6816ddce099da969ddcb461bb"
  end

  depends_on "go" => :build
  depends_on "awscli"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
