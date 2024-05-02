class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "c4a3a7c000678176851b6d2a296644a1ae23a3df307afe69cb33832b7ec2ed44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2d102337d7aadc424b43e985de6f367b6e63dc75d34ec43e82a1fae48948313"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "696697fe6bd3de6c44824bacac86f06d07bba0657cb70b6b06cf284c197d8d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7882669b21629f14fe09a8d57dafe22437075d56e28a4ae55676136d5c53476a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3688d457ba4f8b9b4663304d35868a949e8e23c2cf29873827d7bcbd988b1f08"
    sha256 cellar: :any_skip_relocation, ventura:        "b899168f0aa484e10e3f197a40ed1e168b5fe938f32fb9ccf681db4f0b99f9b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2c0d37e2a70aa3290e0d057785e2f236d7edc7d1322b0d18063e23277f79b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "879d8ae8c2ddee95b40ec5b3f48352f3390ef52a69fba0f33708817a2e7cc05b"
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
