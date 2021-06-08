class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.51.0.tar.gz"
  sha256 "a08fa6a80dd9d270a8078c3545c3ddc423ce67db669eb9e892bf0992c615def4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41847f6806b9c3eb24bcb9b4437dd07d7d10991bdb40b6946b9d37a79fa73191"
    sha256 cellar: :any_skip_relocation, big_sur:       "9bfd90b6aca121fdeb269cded36889258f5f3c29458f1a21f9c30ac28042bce9"
    sha256 cellar: :any_skip_relocation, catalina:      "cce8b27a554fcfd2d75ffe9eb5c942bacfcff179cd88887c51c56f70f9bfe3dc"
    sha256 cellar: :any_skip_relocation, mojave:        "77bdb5c7fe88f9df70d018aa12434a45ee1ef8cbe1ff91188ba396d4d4794693"
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
