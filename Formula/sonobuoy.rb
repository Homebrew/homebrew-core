class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.4.tar.gz"
  sha256 "5c3175d3aca408ff8e4e77b716b95ca0be0859fe600912919d3897cdbbf77bb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22643fb291902c896897832b0a8dd451ee6f02e9420b3720dc9f45ec224f7352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e71a07fb9d03d175f0111607cbc0c07bfc1cd663fa6a1a03d69a64333d7b2ded"
    sha256 cellar: :any_skip_relocation, monterey:       "84ee96c38ba58776fa0a6565195efa38d34d568d0e2d3f259fea692885d17c58"
    sha256 cellar: :any_skip_relocation, big_sur:        "47977b64f18f2cec3fb0bee24436225083fc5190a27a247a96908dfca62f5ac1"
    sha256 cellar: :any_skip_relocation, catalina:       "ea127d38edc308d882edc8c227ff58ee85982c5218e113e61ef91af2e58e5965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9cb85110f52994c7d95b1c44f514e27d2b8095a0568b79b17577bf38cf9d9a8"
  end

  # Segfaults on Go 1.18 - try test it again when updating this formula.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
