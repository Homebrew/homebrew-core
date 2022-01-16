class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v4.0.0.tar.gz"
  sha256 "ca325324e67c93f3b1e65391911c35858819e2028b3564bbed9d1c1b034f89b3"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8ac60b4d2f69eae9115bd1e0dd561f5b5e9fa07b4097fee73e6ba5b2dfd9e30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22278d9d21f6e6841da1041d4222abbbc195adc8ee4c724270045e3d5342c11d"
    sha256 cellar: :any_skip_relocation, monterey:       "677b8ec965569c07c889af07fbeae19d6b743bf8401638d07146a6cf77cd152f"
    sha256 cellar: :any_skip_relocation, big_sur:        "94b2977710fc47c004b278c95073868e228b5de7a0640aeadcebeeb1afeacdab"
    sha256 cellar: :any_skip_relocation, catalina:       "2d3760206b808a78800fa62316cf6eb28b2231efdd7dfcb7117651801e08424a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19ba844d0201dedfb114df6135a94ee642449a106a9fa2b8c17849f812cc359"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/internal/generate") { system "go", "run", "main.go", "../../checks.md" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 2)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output
  end
end
