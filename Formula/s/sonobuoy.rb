class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://sonobuoy.io/"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.4.tar.gz"
  sha256 "6665ad9ed741ac721d2c62352dfe555da16569daece8cc1d2c1ae5a2d18dad15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "588cc92c6ea528b1701c96e1b5bb7d68c424add0b2353011186dd094772c00e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588cc92c6ea528b1701c96e1b5bb7d68c424add0b2353011186dd094772c00e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588cc92c6ea528b1701c96e1b5bb7d68c424add0b2353011186dd094772c00e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4711a1afe5ca0f37274374a17fcacb88cc6274c88d5cb82083bbf3bf0aed1b69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ed11988d2d86a58f92d4b15ca336ca107c5b6d60f106b130f61be933b3245f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a328c9d18793027bdd1b12dd3c43b7b6bf84adb8e91fda9da519bfaee495d90"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sonobuoy", "completion")
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
