class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "8cc661fefbc959262991d4cc4076577e428d10b08aa0682ec32a5ff0bca56e07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6d11feb856d73d5b12d9d55fec58a1ca7ed53f71ac1fb4bf89daa6aa879eb807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c090ac589614c824d66eb933756a5311abb34b871d0680ec66f13f1829ded18a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c090ac589614c824d66eb933756a5311abb34b871d0680ec66f13f1829ded18a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c090ac589614c824d66eb933756a5311abb34b871d0680ec66f13f1829ded18a"
    sha256 cellar: :any_skip_relocation, sonoma:         "291c2f43b0744e881c97c74dd8dcabe257057f4f900e49517ed8c77a87c81855"
    sha256 cellar: :any_skip_relocation, ventura:        "291c2f43b0744e881c97c74dd8dcabe257057f4f900e49517ed8c77a87c81855"
    sha256 cellar: :any_skip_relocation, monterey:       "291c2f43b0744e881c97c74dd8dcabe257057f4f900e49517ed8c77a87c81855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c189356575250c12516166ca905fe9a964ceb431ca938a27ef792ad55135b5"
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
