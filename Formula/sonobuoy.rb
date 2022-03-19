class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.3.tar.gz"
  sha256 "26a3bf677a7013a3ce6da080b2c983c72cfe7d5fe9e1d4964df0e6f0abb30419"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d504e6b40ffe475d5fbd7aa2b0acd746a883499b8e832c0c1ed759ac343659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22274a13279e829366c56346f14b214e0389d165ea08207f58e905cad9b717c2"
    sha256 cellar: :any_skip_relocation, monterey:       "115413b39a7f32aa4e9500386cf424e02f01ce5bfb97a8ce51e9404cd8d44779"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3a8e8f544307ba80bd67d8106e8c2a4d8f8a4f5a36a8d65af4de22dd5a04725"
    sha256 cellar: :any_skip_relocation, catalina:       "3be8e4a86df08df761c530c30a7b49161c0108ebbd89eba8c7f59a150d50b95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae93e6c2748cac69e61d591b1e673c8b64d9957a94055f84cfc977868aff7f55"
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
