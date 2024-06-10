class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "72e207811c053a56ca5a366ef6852ea7918aedce1d2562c4e62303ba45524297"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "653cc2994ff86dd182ae5f4d600b10a0cebcc16f4630afa9c16b2c49a7f3f168"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18d39a3154ffbface140b71598d9fec3c282c634013d25ddd794b50fb0209327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62942fbc8aacad3bed8a68593cba68bf0eca46e54c4b6241536ea4d1ff259e7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "815e339ed7b6e2010007b15c8602889e1414fe738923a98582c1e1af441aab08"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5914e4acf9818c234b6a6a3736c87d5c18b1b23a52cbef372da977b756d280"
    sha256 cellar: :any_skip_relocation, monterey:       "2734438422b7cb72ae73d51a5cd60404003e08948d0363dbc53cafc9c956b5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ece57261c3afdf7119f5287d95973a05a939a55333a12764bf1ec861aa63de10"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
