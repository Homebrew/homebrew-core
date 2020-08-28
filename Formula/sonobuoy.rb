class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.19.0.tar.gz"
  sha256 "973d80c1682e52e69c19104cc0080deccdf1ed800823fef4ad98bba3374cd8a2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c8f75cdddf92985bea34bea7ba42a2daf2decfa4a7d5fe21501168209cb5cb2" => :catalina
    sha256 "43c86b74e6075ab77122e858e74d428dc3efcc04c65f41c62a948019326df4e8" => :mojave
    sha256 "778d594f38f8ea899567e462584cab34b7e318b51333ac3590e5d66dadd5b5fb" => :high_sierra
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
