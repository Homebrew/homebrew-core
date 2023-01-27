class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.15.tar.gz"
  sha256 "b822125ab0d8f67c0cc12113e4c2c8435ff48cf36863b6b298d1d06bd37f630a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3125438a5efa9f66ebeb9a39cc06001155c2b370858c9cb63f42111b0e055b0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f186235fad405783f56b1febcedbf9eb8ff3e0b73744fd5aa84dce383537eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14baeed333624bd9aea27521e98bdf9224a220c76560645c55525ea17de64cc5"
    sha256 cellar: :any_skip_relocation, ventura:        "8fe83c3bdc7b4cfb609ef8d0d412ee9d4d231efa90a6a00c6e517fa8408c11ca"
    sha256 cellar: :any_skip_relocation, monterey:       "bca6d675e8a393891f34b119c905f22ebe6fe8c15a54112b446ddbe7864f2c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "3807cac8f6adcca9bbc7797fda1d95b2dd128769d52c901deaaeac8860cfd4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51011bc0200b87df4c1a50f6f7bec7ebcd49256cdfda95e29822280e92bfd99a"
  end

  depends_on "go" => :build

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
