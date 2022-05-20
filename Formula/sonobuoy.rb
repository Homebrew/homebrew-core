class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.6.tar.gz"
  sha256 "d2faffe1d68bcc554d201af8d763a2a820c0ed2df8a73732f5996475b94c05a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05c5aaaf1aab1720dff1cfa9c2898bf70b20c267be998fac50b49545016ac9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b116b03cffb9b778ef3811a1fcb36e86e95cb93a0b568ac4f86d6105c0fa9f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ede35cf1fc40860619216efbac2257c27dea9d97c12ae44ecfec81df72043bdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dda9134277eac93cd6f9835900257d96bbff8ce5b79d1c93298b2dab51965eb0"
    sha256 cellar: :any_skip_relocation, catalina:       "f84893fffc0adeaa9c56e510eed70e850fbcc7ab0bb39d8408c4be409d1db010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d779af929db705821f0a3119d1d38be015526f0d776467277525013fd9e4ea31"
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
