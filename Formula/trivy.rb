class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "cedf0bb9713ed0f625974a09b889b12223979fa3c8871795612dac71583455ae"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "714acb89d4ffbea890a7daaabe6a70ef5e25ef5b183bec5b70ef95aa5ccadeb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6976fcf9d89fa427d3c471b7563865407459ede7bb8aa5c879d7b47e65d239c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6df493d5fe1a29b39deaee5c888acabdec88ff1d7ac5e4f9fb2b140dc02450ac"
    sha256 cellar: :any_skip_relocation, ventura:        "70b23b1397dccde07095946be031f3a84cd0837f631b55998bf99924a8b59c1a"
    sha256 cellar: :any_skip_relocation, monterey:       "0d3df5c1a0c12e2f53003cc44cdd2d4a8cd3619d10425b2089e51d5462a84d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "b446997a6aaa12ce11416b2abcef44df73860ed475ad2f676288bff5b2041f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1131d7bf1aa800dfc039b4ed588870b61d56e0bede141061e8a88252cf9913"
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
