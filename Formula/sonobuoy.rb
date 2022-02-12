class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.1.tar.gz"
  sha256 "4aaa1cfa87ef589c8aedd1c43c78acd4a8a590e2b499627252d0347cc8c22602"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abfa2dcb072ca7515273c72ff5420859043a3bc6eed29926d89616afabcc65af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e11f09337902bf06d7196ce167ec8f4484e3c5d0061949a605c99b0d379555e"
    sha256 cellar: :any_skip_relocation, monterey:       "d598b8c9aa35fb68bec97c13aa155ca87c5fb27170a4faf6da5e2a1fb035b36d"
    sha256 cellar: :any_skip_relocation, big_sur:        "99e1d4afccbb08f92410414bd9b6eb7225184b0930688b6d16b026d458033985"
    sha256 cellar: :any_skip_relocation, catalina:       "8a30c7ffc461153149b7445b5d134e2c45e4635e3e25634b5cadd9c8bd1c5565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6907af4f535531e35c638a9299373aa3c4f121b985170bf5e3e41d81377d847"
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
