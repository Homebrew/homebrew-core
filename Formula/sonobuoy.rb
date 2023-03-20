class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.16.tar.gz"
  sha256 "a20c806a1fe9f977514cc22695bc1d51ac48409bc4d5a2191a5caaa8e6c8b121"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0ed8a9429c8b4344b247fcd8ab0bbb94acc358b7e7f5024d8b279da4ef96454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "354ccf760a66778309bdd3ca14ea26653dcb3211698a9b4044443741af309a2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0ed8a9429c8b4344b247fcd8ab0bbb94acc358b7e7f5024d8b279da4ef96454"
    sha256 cellar: :any_skip_relocation, ventura:        "973e37bf46983269400e0b4cc5a2cda89d4d0c7c86b00dc9774b92626c020230"
    sha256 cellar: :any_skip_relocation, monterey:       "973e37bf46983269400e0b4cc5a2cda89d4d0c7c86b00dc9774b92626c020230"
    sha256 cellar: :any_skip_relocation, big_sur:        "a245d65db647bfb783abbea2cc7225093e6a3b4b8fac07805881eeac622c5afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07cc236f51a35e36ddcbbea3a10a0e7e2f5f8eb32070a2638033ccfd8f084695"
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
