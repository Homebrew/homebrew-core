class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.9.tar.gz"
  sha256 "fd1df6d90a2ff9d6c1a21601df5d2abfa212821e3ee077195c6a9543df4d635b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc2dfed631beb449aa69ffb037d2bd5b15a7da4b14e927ea7cc5053c7479ffbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a43e822a87adf951088ec1242d55c1303e16b719bd80a633fc5166454213a2"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0c50eae67b7b43b0b45235866d73b3b81fcd13964f65dcc20970868831d051"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcd4f4d1a83a98e49542034d21cfefb495cba0ae5c0773425b3ff78a58cc0650"
    sha256 cellar: :any_skip_relocation, catalina:       "50b7236f79099248f9898d2db08c04d49bb4d73e0d97e8829f5efaa30657931a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7d35d26ecd65f9dd520550e4eda0b0abe9d62d30b866f1a45751b30ae77f6f"
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
