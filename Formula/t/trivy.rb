class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.50.4.tar.gz"
  sha256 "c87c78d322f1e2673927f14a7d8136faf179a9f9120a4cd42c6f5a5f2e096c45"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d632d527ca9e832eaf41c7748940ec4fe5e9caf1017390edb7973ee7d85273d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dd8eb06a08ecaa2d30a33e88d0ae342245d2782d51eab5baae1aa6db61c71f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6804fa7b957b763105209bfee3e9851e261fbb62a69ceec01e01f2c0d1a175a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae27e4cc50fb7ccfadf3cb5b8a8f560d1d2b01bde5ead77b7637c1c1343994c4"
    sha256 cellar: :any_skip_relocation, ventura:        "31e6472287df4d7ae5ff61ab381217ce664170bd0e24e60a578515ffba4c5bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "752b2419c311693b4357d4f50582b273b6e139fb0dbfaf7f8f6419117ef8ba29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928191d94b262f41e8a61298da3be53673f48680a2eccda1eab46f49f1f5e4ff"
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
