class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.54.0.tar.gz"
  sha256 "eb3cab29baa7d35abbbd3d5657e97d7f0c4e6440dc824384e459c719cf0bf007"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bdf70c480abc642bf1a788771f948c78522b3cb1db733c87216c3cedef5cec97"
    sha256 cellar: :any_skip_relocation, big_sur:       "02e5f5504e71c6e069bd4a67032609ae2a3609ec187960ccbcdd921588b58d62"
    sha256 cellar: :any_skip_relocation, catalina:      "48666d55e9f07e9c2a455651619803a97ba1d73f4e950209f9f1e41c561f1b67"
    sha256 cellar: :any_skip_relocation, mojave:        "292668d4da3ddb77e594156fc790c9941c080ea291faf7b97b195f780d978a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0878be725dcc42c8c9cadad08d6659dd555990b4712751d6cd304c0340b6503e"
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
