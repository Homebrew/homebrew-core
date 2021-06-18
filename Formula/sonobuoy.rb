class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.51.0.tar.gz"
  sha256 "a08fa6a80dd9d270a8078c3545c3ddc423ce67db669eb9e892bf0992c615def4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17675e5924fc9de1e33762c5c8297756a28f07e232bf503df838f793ba4c1c22"
    sha256 cellar: :any_skip_relocation, big_sur:       "4706ac565a6cb2a298bc283e1f34dcbf59be5077b1df2ff1f669cbae88291591"
    sha256 cellar: :any_skip_relocation, catalina:      "27862e0a090a4a4cf6749b75c02c0c32cd41b34a524d6be3e2fdfb25c06586c1"
    sha256 cellar: :any_skip_relocation, mojave:        "e63854a03a4817c6cc49966bd115f6fa0ac4989d2a309df052eda43891404eb8"
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/vmware-tanzu/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    system "go", "build", "-ldflags",
                   "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}",
                   *std_go_args
    prefix.install_metafiles
  end

  test do
    resources.each { |r| r.verify_download_integrity(r.fetch) }
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "all tests",
      shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
  end
end
