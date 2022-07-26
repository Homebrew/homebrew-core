class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.30.3.tar.gz"
  sha256 "7ae32c31cf3b4e3a32729a65dd82004d16a743f4390f2aa5e0976c250c605777"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14be431b76deb27918a62c1691ebd462ad00d70eeccfd82cf5f50b3060a9e9c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ab0621f3e305a4a677272806d901a059c4bf14f3253bb3e5301ddd15b74f680"
    sha256 cellar: :any_skip_relocation, monterey:       "d101a6dee3ff0d9171c9d13e5195161fce237a7bff2adaedbba89fce6761315b"
    sha256 cellar: :any_skip_relocation, big_sur:        "68fd19448568fd5c39b6dba4474dd1435762672fa30a5ba42128bd038e4f133d"
    sha256 cellar: :any_skip_relocation, catalina:       "3b947cba5f532c685dc1cdbfc52e59705e7094895dc8317b4aac921b2a4a4b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "507e82d4b2e4409d5c4fa4d3db85d450858d9caf56e584494e0cc2445d7bacb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
