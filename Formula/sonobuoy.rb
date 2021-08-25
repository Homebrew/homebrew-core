class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.53.2.tar.gz"
  sha256 "b907c8723ca9549b31996ff95f72a9a6c1e002ac76943a2a16cccf1b4b2f68d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb2cd2c8008283295ff7ce3629a3212a919356e0b25556b8446b3ab5cb426da9"
    sha256 cellar: :any_skip_relocation, big_sur:       "b24c98f504099cc03ad9d2d90d430958956f25efee7e6c2d4aa6cfd423d9ca25"
    sha256 cellar: :any_skip_relocation, catalina:      "8a8ee30fa5f0979bee6c648114fdfbe5dba2037c95ce61a6f7f92aeefb0c9f9c"
    sha256 cellar: :any_skip_relocation, mojave:        "1ba00ef5fd5f066d1dedc654380e7a7766ea3e352ec7a418faf22300493c4d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e032c7d0e8fb23c309b5d4399553e98369c28c4637cd8115b3a2ea3210db22"
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/vmware-tanzu/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    resources.each { |r| r.verify_download_integrity(r.fetch) }
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "all tests",
      shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
  end
end
