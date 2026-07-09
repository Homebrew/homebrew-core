class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://sonobuoy.io/"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.5.tar.gz"
  sha256 "77eab0b152bbaf9836885630b92fa7ab3ca1e561b8db567d9401305a21f166a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7c10513bb921264169aef710eb983e686dd4e767199a2b0a49cb591bcecfdf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c10513bb921264169aef710eb983e686dd4e767199a2b0a49cb591bcecfdf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7c10513bb921264169aef710eb983e686dd4e767199a2b0a49cb591bcecfdf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd081f74c99d87f5b1294108f4bf8144ece78ec27deef750a011eb6886426c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22e2cf9de49490a7d3c6baaf8190981c3b0769d491b06966c4536b78a786ec40"
    sha256 cellar: :any,                 x86_64_linux:  "c167b3d95ca93752ad0f477b746a1ece1ec799951e3dce27446374239af409a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sonobuoy", shell_parameter_format: :cobra)
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
