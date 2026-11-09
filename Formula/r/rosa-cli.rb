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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bba40ba31e5e51d75a8d4f2db3c800167e54cb18927b5480defff45a866a4e0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60b5fa33b0817c94040b9b7213d58847f9c91c6ded2b5f787874b4daf6f7f219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00cd81570c9f781893f8f88604583c30e9ae8cd60bcdac29e43a1e713e600d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a44e291caac26033928807f6b4cbefe7ac35ab44e6b6de22aceefa15e8826f1e"
    sha256 cellar: :any,                 x86_64_linux:      "649fcfbb0e995febcbaa94255e791c34d3b7012b2c5b162a85ecee2f54063cc0"
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
