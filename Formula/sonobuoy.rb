class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.13.0.tar.gz"
  sha256 "3e7976245097b1e8433f845e8344d4e9071d4b7558e497e8902abe3a7298f49c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed9bfc6d93c21cf6a70ad2d462fff5cd156252b274f18bc718496eba8c82d73e" => :mojave
    sha256 "b55c5b42e1852b1fc0e5591b57762ec5e3f7c26b2290530630759416cbe953f2" => :high_sierra
    sha256 "ab9bbced7de19299b6a2b0a763e6adf699873fe68c34a77deb28e4b205bdfddb" => :sierra
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
    output = shell_output("#{bin}/sonobuoy gen 2>&1")
    assert_match "name: heptio-sonobuoy", output
    output = shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
    assert_match "all tests", output
  end
end
