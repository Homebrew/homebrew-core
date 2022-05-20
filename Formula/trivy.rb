class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.28.0.tar.gz"
  sha256 "fd95e5353c7e834c87f4a6dfcf7ccbc390da5e0dc9287cedf341a7b3c5dade9c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fee9e79df5b80ac210f7cfc459ecd0d64bdd5b437990028c221d95b7f787693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e368ea9fb6ba920bda39d72f67134660c4178676fc7975f08c7a91b74cb52f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "64ea1dc6a9d548bf66e9800df0be56a24de4cbc0b113947f75328c430cb210fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8741dd1744ab1a4be9f1a5cc7aebd1989efaccabdcf2e6036faba6da115bf59"
    sha256 cellar: :any_skip_relocation, catalina:       "aa22947918b07ffbaac123c592ddea9766623827ff8a4f7d0b57b6c20c5c4b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e0bf37d667574932ef74a56084d1ff2f00f07b7853e0fa5ba3cf2ef4520395"
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
