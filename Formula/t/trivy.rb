class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "f78653f62e1192288345db5e31fb2197946f64c3fe3aa12d730bfedc01d105f6"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7b14fa680a374bcd5f7d1f3a3bfc61a8f1495e7d64517efd2251592d25eb57c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeba18003064b55f9a71f13fdf7484d6b211704f3c7329da07d75cb5f22c4443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3fe9d8605eaa323eca9543f8d4686fb06dd7d5a6bb010ecba1359ef5f9f4e99"
    sha256 cellar: :any_skip_relocation, sonoma:         "02a062c83c9debb08543509459176ac16a93d36760008f7601de360f3200872b"
    sha256 cellar: :any_skip_relocation, ventura:        "e79ccdb675cd892813751c38d5774895498ab22b7db8a02980d364ee2f559784"
    sha256 cellar: :any_skip_relocation, monterey:       "681305eadb5a980469372117431ba7232c915f312dff133f800e050754218050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4acdb370edac81e9718aa8b54572ee3b841486e2f65c1603359467bd8b720f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
