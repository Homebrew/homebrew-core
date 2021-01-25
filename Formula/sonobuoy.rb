class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.20.0.tar.gz"
  sha256 "e64f6026087277d22f1cdc52cb7ff8bfb19ca3671ea6f882c2c1327675b07b9d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7f3e8d91d907888ebe0585f29b01c64f25cc829f55e3aa0a896d9ef60177a70" => :big_sur
    sha256 "d4ae3e3c577c3753e15b75cf0af1deb822c441df381d3d1d923a9337684d62a9" => :arm64_big_sur
    sha256 "cf34ec271d9a63ea979c379cfb3c30828d4b53ebc3d691d4b7798ca83c7fb87d" => :catalina
    sha256 "d59cd7e3d92970fb71818826c9a93d3ced9ce9179493d33914df125bbbaa78b0" => :mojave
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
