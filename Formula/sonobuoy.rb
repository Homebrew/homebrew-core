class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.18.3.tar.gz"
  sha256 "7560e2e8b9b8ebcc4fcfc7737f6b039d061e153f7d9145095c3f051bf3d6e4a1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdc8f8081c9551b7173923f9276f7903a1ade71d3f19858a183ad18fecee3cc0" => :catalina
    sha256 "29a498c03d5d0b9d0d1040fe000664167834498e041350203fcbcfc81ef03141" => :mojave
    sha256 "ecb8e73c10ccb15afbd6d5338ff3f900b30a1a192023ebffe9df6797ac51eae7" => :high_sierra
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
