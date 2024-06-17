class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "001b02cdf03da2986001aaa9b21170d1705757f33cc3361fff24fb97de873500"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "850e07b21307690668aee2aa0d6cadfcc731ba1d95c0bdbcaa4d3ba285854521"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "948631fad1797b5d6b50adfc93ed165e786c6ce3e7bd6ad124cfa750d5ff2fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01bc15158a918d5247101bdd3336a3ef2d3d875fa20d3cb1147627a983d2697e"
    sha256 cellar: :any_skip_relocation, sonoma:         "83fd06c1b8e68fae5b431971ca872f5eb61e80813d1c59cd9644045f87d6a6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "8a9a727284d2212320d3a53500968cfa1eeda059b8bddc6e7dc2837dcbb7b7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3bc0ef7350957fdfddcaa75e73b916cba7a185a1fb75841ea11a2cdad9e3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c60d0be4ad32234b48afe4144bcd32a05968dac6b7fb2ccbfccb816991ecc2e"
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
