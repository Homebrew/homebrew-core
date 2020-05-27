class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.18.2.tar.gz"
  sha256 "9f84bbb7d443684f008e99c233f4ed6da23e142ddb25818842786357efd1c078"

  bottle do
    cellar :any_skip_relocation
    sha256 "56f884c7a0aeff6eaf68d1129352a6f0f984715275304cac22e8e5987ac86b6b" => :catalina
    sha256 "9c718808e2d136e2292cbb707f288191c1d9c127e39f9d1bbe9e462d9ba44f86" => :mojave
    sha256 "f40f52dfa426ec4ba12a2a1832c7b3d5a1f2afc3f73bd5190d09ca491b144bae" => :high_sierra
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
