class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "e9b7224a8bdf4814598759fb0e9ae20383763a4ea5c80f0e119f168f8405df32"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1e290694ef3fb376196d817c7579d6fe9e5dfd9524e386562272eae040c66b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe45d7fd9fe5c231a5c28ef516d40017d191d3807cfef2c7ab77c91158a8afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3026adc8b2d0377b8d9bd77400fc59ba3260ac267fddb3bef057115fc2fc4ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "de46044c130fc84bd2f599709bf8be28df93185129f618e826932a661832f8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "6d93773dec1d34f85f03cc1cda69ef00ad2db1156fadafb462d1f3aa8c27f9bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd1658929cb24d7a4b2314b411876195b3559a655a96e6ffc77c60fe71c31e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad419e6eae06cb1df7ecc1b2503459f04facf5a7ea6be3e2e9a1b7a17b89b16"
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
