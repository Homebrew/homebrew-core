class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.53.2.tar.gz"
  sha256 "b907c8723ca9549b31996ff95f72a9a6c1e002ac76943a2a16cccf1b4b2f68d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cad3b6699d859408e56d4178e895a7daa4a5981c598a4a26d3af6dfbda8b5326"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec5a4dbe0498a470c0f0899d73eac4a489d865493445a482e2f9b41b80ec6e8f"
    sha256 cellar: :any_skip_relocation, catalina:      "d39ab320c5133e52611bd80f95234c3bfc9614e06bfc411156015fbe2cec4b82"
    sha256 cellar: :any_skip_relocation, mojave:        "170fc45c12732904420475124abdd7d4fe8c69d9f039ee355464e08472d06045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0f92efb85063f1eb5be61c3a76cac10242b2b1dad8d4ada59a670018499e12"
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
