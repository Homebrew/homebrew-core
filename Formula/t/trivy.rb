class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "e7caeeaafadbde56c18fc72bb6573b2bef6caa70b7a4ef7ebde73db0ca56211f"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "431e577aa29687890a68f8fc530bd262f2952fc22075f770261d15019ed4033d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c1e8442a244d500d5e9b6c640ce9d133def679683f8fae6be35dc771734b7c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47197a19bc529f2ef790d53c4a51fd0fab96656618c2a916199ca7801f13dde"
    sha256 cellar: :any_skip_relocation, sonoma:         "98fb937bbdb3563e9d3f4527559161b189d0693bd0c0b560e8345c5718ba2559"
    sha256 cellar: :any_skip_relocation, ventura:        "6e0d8066ade84e8429a31b38a649031b7d70673ce28750bf27fc3494a630f269"
    sha256 cellar: :any_skip_relocation, monterey:       "60a4e27fba4b0b5b12c0c05501429688288d842277c0ebdaa7f66607c6daa8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c0ca495ec91026ea69501560898b6d5fd6cc346d113cd2932d39e69e2090cc"
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
