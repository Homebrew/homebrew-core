class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.10.1",
      revision: "6c5d964fcde4b83fa5ad5e40060e9e5ba920cd2f"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88520cc66435b6a7da9ab2c8324db920d2470c099d1e0ef3adfe9ee99b1df6fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7490bb435c35762323d039745166d0f88548d8cde3360234c8aa6a7e47f0c49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb7bf5a000109f9f98e3c062f69286190b0501ed7fd6a14f788e62702de7d45e"
    sha256 cellar: :any_skip_relocation, ventura:        "548c84887d7f1d6ec46ef359ac0550d7a3da3cd6897959202d9f1ca6f906a96a"
    sha256 cellar: :any_skip_relocation, monterey:       "b081bb66a1742bbd7c961adf6352a7dc7f5a11c57d61c13d97c8d334cb7e6f3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd46209253a05abdc55da275a2cd249fbbe6cfc599d984e3a4d95f0bd7651bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039094eb8f737b3306a3671692212f3cccee1337e5296d4dc6cc4d6486faaa62"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState=clean
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
