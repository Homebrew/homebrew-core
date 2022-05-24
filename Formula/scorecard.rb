class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.3.0",
      revision: "6406cfd4e34156a5ad04fb4207bef0297f83903c"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ef69758e921c7787d9d96b2e390eba1fcac13abb05200de9793098efee99e71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a2307b1d24b96510d303575fce94b65e0f5c90e3f4dde04f658d6c5ddeb36df"
    sha256 cellar: :any_skip_relocation, monterey:       "636a13136493d91595943b70cb64bc6ab11af755facb522ba62090d048556030"
    sha256 cellar: :any_skip_relocation, big_sur:        "efe8d63f67cec9de0e345f785087092ca11c32bee58678242864213f68f80845"
    sha256 cellar: :any_skip_relocation, catalina:       "6a4a0899deaa67e5bab7939a764fd9bda9f8b7d05f6a188c951c5c208a6ba0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca6cf322dae555039d037f9d54066bdcd58bbce30849f8138a4b28c2e5729c6"
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
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 2)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
