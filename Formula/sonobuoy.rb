class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.15.3.tar.gz"
  sha256 "4b224f16f320dbd66994087e408597f4d3d9b685390def030112fae957e86168"

  bottle do
    cellar :any_skip_relocation
    sha256 "f60c3c40d5e061d6c045fca78146110b268373ee68dcbd27f89fc487087998a8" => :mojave
    sha256 "e3a780dae5cdc66eeb932b3362d86bd4cfd2c0c0a9e76e12f5b5a7687414b2ca" => :high_sierra
    sha256 "c0f03b30c15ed881a1e8086fdab15e12da2d252db9fbbe18cb1ff41081faf85b" => :sierra
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
