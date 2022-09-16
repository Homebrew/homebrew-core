class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.32.0.tar.gz"
  sha256 "0adf04783fa4411841926d54d34f053f08546b0385d6d351b5828f545890fad3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1787a579a70f4311700da31efcb9e091176ae5c688d8fdb072c8647adfb2ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05b4ee6c113e3fc5fbd37bd42fbe69a679126a8e88aea209d978cdc76cc8ae37"
    sha256 cellar: :any_skip_relocation, monterey:       "df8a19d2dc3c657c3a48b824a2188c26bf2962e651d20bf2ca2b218683bcedb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "280e9a5b109c3a16ea82b160c86970d1ab2980f272ea5153b95706f5d4284fd8"
    sha256 cellar: :any_skip_relocation, catalina:       "65258b29ab15ce44dd94c106300e49bedf957a998d0684875a1bd47832d1ea6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ff0896e973eae042425b1e99851ec3ebe5291d3003dc4382ecf005ea98f10a"
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
