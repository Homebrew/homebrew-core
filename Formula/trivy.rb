class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.37.3.tar.gz"
  sha256 "fbd85f2b1b0ebe9d3749c70cc6c55cf579df4d58ed7740fba96021382adcb54c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b070929cf42b27f92e1d43db5db639ff381c358cccdec27ec6f84d48db8bb5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6833ca46e84792178c7e1220b1782b5941bb9e5064eda4028a932dc787c5661a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59476c2b077451a98865fddeb1b1d2cbd240a17c78b4bb5883705dca07117f66"
    sha256 cellar: :any_skip_relocation, ventura:        "a0aeee2115f481de4deae401ba7f9db62911958352eb7854c275db83ea6eab00"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7a6ca88afa73a8263bee44e281e34bcc8a07f2cf46673ae6bda2973543ddff"
    sha256 cellar: :any_skip_relocation, big_sur:        "88563c81d686ac60e78f0e506978ef50845187eb1f6e98a548fe5b4dd11cc26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d095da259599c2de68a48438ffd7da2b2a1ede056f594bb6ca3f2c3083cdb191"
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
