class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.68.tar.gz"
  sha256 "b0544368eb6023d533afb8c75ab09d0fa6ba537f416c9449d9825e0f7a7ff9ff"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bfa4151a55da72f2f843ef4b6a2e7f1972b619592be100808107ca25b20284b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33fad8f8c07748642f470ee26870d220b38558910d69050ee15e44bad56f3e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dec97a454ffe9c94d6701c8bb1b7e253a04e152504a9a68b12fded71c5c2ad4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b4dfd6bd88b87f1e162794d475a1eff8b8ec2734c07b79f681617fb1bc35e23"
    sha256 cellar: :any,                 x86_64_linux:      "d8fccdc5abee2e4db34680e65d65e039f091b56f6d31fabda3eca052192caabc"
  end

  depends_on "go" => :build
  depends_on "awscli"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/openshift/rosa/pkg/info.DefaultVersion=#{version}
      -X github.com/openshift/rosa/pkg/info.Build=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"rosa", ldflags:), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
