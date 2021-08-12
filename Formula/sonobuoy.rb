class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.53.0.tar.gz"
  sha256 "379b12216d5d153b5f9ad051087f512d08f3603b6f7aed100111cf1fc32f1ff7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b5c970803cee4c1f1cec32d37a95262a170dd070b1445755605f055223f337b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9220dd9a3ce6f70b71357ebcc663728c16a9e3ab336b9fb6f5c09490e342ff16"
    sha256 cellar: :any_skip_relocation, catalina:      "79674248ebaaeb3163d3d6b63ba450d2154e26cf76e59be30a18275e4e71833d"
    sha256 cellar: :any_skip_relocation, mojave:        "c9e360ec42b8e9acfe3d8ae8292da56e4debfd21cd8f2a1cd21f0eb662afaba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d857e2935e700ed3ab87d6d12652e4b3683ddaf13be555bccc38ea8d07e2099"
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
