class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.31.0.tar.gz"
  sha256 "29aa7e34d368e09bbf0a91a37ce9a817805580cb322dc128ee5ebd53c6f6720c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec701697ed69761787e7995f1a46c60a5bab24e080cb967d71a62284a21f5402"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e31533e9c1209c54b84b246c27b27b4f0e6f8f2679815146f054dff25924d47c"
    sha256 cellar: :any_skip_relocation, monterey:       "13669353ab123ededdd04c6a71bef2643b454ec8d192d3fca741937dfe369acb"
    sha256 cellar: :any_skip_relocation, big_sur:        "50b14e7e6aa93847d0ee3e25306127269cd92653f8d4900f494e4528a7b6af57"
    sha256 cellar: :any_skip_relocation, catalina:       "a15ee13f0455c15e1d2a35fe00f57e8a1e093afdf09adabbe747d55d27311f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f29e444edc1267978c7432e9120eec796e3a72c9cb16d65a1522c8bf39c168"
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
