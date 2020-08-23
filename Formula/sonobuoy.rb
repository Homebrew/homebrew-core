class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.18.4.tar.gz"
  sha256 "94af6512fb8caa6dd268ef6ff30904895691dd494cd9337385ef036dd41d0610"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5bd020fcf2c5068c50a97f37a465cd1846bba916760e524def3498ae5734532" => :catalina
    sha256 "d7e49cce7fa5ae820b73b2dfe7fd375dbaf1b98b49b530f434248f7866a4e1c2" => :mojave
    sha256 "0d0f7d6801e1b86ac9827878857b1c497810fc5c3c23e0b4e6394e73731dd5dd" => :high_sierra
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
