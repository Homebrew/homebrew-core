class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.16.tar.gz"
  sha256 "a20c806a1fe9f977514cc22695bc1d51ac48409bc4d5a2191a5caaa8e6c8b121"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c603435584eba78bd0de61c0505072a5b13db9d83e816eb2f00334a07ec45de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8c3c1833cda3f7060eefee81db88959902084873119635ba9547887a69d600f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6348b979b714c939d13ebcddb8df6637cb9e0eb88ac4b562bfa6d110d89522"
    sha256 cellar: :any_skip_relocation, ventura:        "4a90561d1908fafe7212e68036afed818a83d5febed1ffeb14bc03756ee4c22f"
    sha256 cellar: :any_skip_relocation, monterey:       "752b971acadeeb1172fada0ec370d6ff5b38b3e3b035d513c031de66df998138"
    sha256 cellar: :any_skip_relocation, big_sur:        "a540eeae17beca6a55b3fbe30ad734ac758c9aa85d0691870a5637e5139960e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5854e4392739ad88d64d64a5a9d76b454d67d91feb939a804461dd5ad85413d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
