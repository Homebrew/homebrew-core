class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.38.2.tar.gz"
  sha256 "48a3504f8554dbbceb8b21f00805a14d3ff141c8085a50c9613312c1637fc543"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9814035b697c528435440ae5fc99c5aeb1bac9595f693f4eb9d8dde040b6045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f757e46fa7a476b7c206ac85e44b21182879942e1ce48d85862531c06b8be507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "517872b338e144a1c8a9ff8f36e6d74a5414c682be3608e220e32fdf7d429aad"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd10250edbad2595e84e75677b4b5cf701fcb05899e3e4ff5f4ae7506f453cb"
    sha256 cellar: :any_skip_relocation, monterey:       "634aef3bb3e1020482a4ef8a317b4a09fef175fecd9b0ba0bfff46d51f476a43"
    sha256 cellar: :any_skip_relocation, big_sur:        "f54ed1be6270ea9d6eef3e61250706931b2491f74a7bfa9c898fed699a8803e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d755b84ed0c9b5583b6c246974c8ec04f260f93e29973783e6f739ff257ddbf3"
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
