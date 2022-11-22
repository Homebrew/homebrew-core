class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.12.tar.gz"
  sha256 "feab53ede72d71f96c3934b85e64cc0a2a490bd5772de1cdd4166ff52a0c95bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b84b0e2e6ef6fb99ee56b1e13f957c93f4f9d268695afdaa3c616b963046d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "430e8b5bf1fbf15d341d1fea65b0c83268771ff24e0a4506110c05d87d276dea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b00cf98f47c4973fffc20b75e01d1d795b557cc37e57af3c3931a190d363e247"
    sha256 cellar: :any_skip_relocation, monterey:       "ae697e58a72277b9ffe851da546cda4123f188c392596111f1c784f0e628fa18"
    sha256 cellar: :any_skip_relocation, big_sur:        "accebdd6d3a4c2e4ce2b5283a4da39fd87e5ff4313c6d8e506e0a68d8bd14e98"
    sha256 cellar: :any_skip_relocation, catalina:       "ceff90dfaf531c09b763a233725947d3b4517ae4cb5fcc071cf7521c617199e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6edc837a500f3ef0cc34730ea64202880f2a7282ba2795829706fd41871e6904"
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
