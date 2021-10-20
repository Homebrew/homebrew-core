class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.54.0.tar.gz"
  sha256 "eb3cab29baa7d35abbbd3d5657e97d7f0c4e6440dc824384e459c719cf0bf007"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb2cd2c8008283295ff7ce3629a3212a919356e0b25556b8446b3ab5cb426da9"
    sha256 cellar: :any_skip_relocation, big_sur:       "b24c98f504099cc03ad9d2d90d430958956f25efee7e6c2d4aa6cfd423d9ca25"
    sha256 cellar: :any_skip_relocation, catalina:      "8a8ee30fa5f0979bee6c648114fdfbe5dba2037c95ce61a6f7f92aeefb0c9f9c"
    sha256 cellar: :any_skip_relocation, mojave:        "1ba00ef5fd5f066d1dedc654380e7a7766ea3e352ec7a418faf22300493c4d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e032c7d0e8fb23c309b5d4399553e98369c28c4637cd8115b3a2ea3210db22"
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
