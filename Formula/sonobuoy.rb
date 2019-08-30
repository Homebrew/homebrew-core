class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.15.3.tar.gz"
  sha256 "4b224f16f320dbd66994087e408597f4d3d9b685390def030112fae957e86168"

  bottle do
    cellar :any_skip_relocation
    sha256 "597442803fcc1f2886f443f2e5fd20e29049d6a3d111a6618ec37a2a7bb357bb" => :mojave
    sha256 "5a0b092aad7d956403b2d3d3cded4088d90e5da1a75252c470a344d4bcc5adac" => :high_sierra
    sha256 "c5108d0a8aba9e388d0f76b2511a195def538de5c7fc2d13aad090601eebf67d" => :sierra
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/heptio/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/sonobuoy").install buildpath.children

    cd "src/github.com/heptio/sonobuoy" do
      system "go", "build", "-o", bin/"sonobuoy", "-installsuffix", "static",
                   "-ldflags",
                   "-s -w -X github.com/heptio/sonobuoy/pkg/buildinfo.Version=#{version}",
                   "./"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/sonobuoy 2>&1")
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance", output
    assert_match version.to_s, shell_output("#{bin}/sonobuoy version 2>&1")
    output = shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.12 2>&1")
    assert_match "name: heptio-sonobuoy", output
    output = shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
    assert_match "all tests", output
  end
end
