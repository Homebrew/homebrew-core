class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.16.1.tar.gz"
  sha256 "94fbe8f7709451254be055cda3115792c470de8adc1c3567393ea657ab904782"

  bottle do
    cellar :any_skip_relocation
    sha256 "81fe204ba342ff642206e0cfae6b2a07652428be5efb0fb700f125185bf2e040" => :catalina
    sha256 "f036aa43d6fe4ddcd9f5468391ee8ef7ead4a0d1e9efc331a62f378d02038df6" => :mojave
    sha256 "f40218ce986b2f6eed8c2a969daffde2d26b7f5fff958b24f38c9982a2303e0b" => :high_sierra
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

    output = shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "name: sonobuoy", output

    output = shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
    assert_match "all tests", output
  end
end
