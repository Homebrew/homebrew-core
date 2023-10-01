class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.17.tar.gz"
  sha256 "6795a8fc3a04014cb9cdf42534940b2bb2858b814c765bfe09ca71a31babbc92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4144bb59128e417734a92834c1d3265a7748444afe9c9d14f6fd125b8f0a013f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d235acf4a115a6fab26dda39765b885b182ed5782039e7337aca15bc021c30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d235acf4a115a6fab26dda39765b885b182ed5782039e7337aca15bc021c30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3d235acf4a115a6fab26dda39765b885b182ed5782039e7337aca15bc021c30"
    sha256 cellar: :any_skip_relocation, sonoma:         "2660669af90c35a73e89f16fd178ddd0c764578a62c1bfb5de332a64057cea1a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b700866d19295f22ce03e53cf26381ce944da2b1db769e9cd024d94876260de"
    sha256 cellar: :any_skip_relocation, monterey:       "3b700866d19295f22ce03e53cf26381ce944da2b1db769e9cd024d94876260de"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b700866d19295f22ce03e53cf26381ce944da2b1db769e9cd024d94876260de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "565b50a24bc8c908131ff342cd6424b37c5b49f1f17b75ab905b86ecc0a8e7ea"
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
