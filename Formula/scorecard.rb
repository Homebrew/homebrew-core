class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.1.0",
      revision: "33f80c93dc79f860d874857c511c4d26d399609d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a16bbfc7c49f62ce079e29dc53998cebf8fef13b284cc0819adb06893a23843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "217619e3c112497e3855d37573815964eb8da8e97a8970df0cb5e3a5aa30250d"
    sha256 cellar: :any_skip_relocation, monterey:       "709ab2224f01859b214d80a0a3c4a1622ff08dad099ce34d379ec96c333484d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a854372e5db0a6fca7563fd036520c296447942fd807200b324027ecd40031f"
    sha256 cellar: :any_skip_relocation, catalina:       "bbc22cca40e2d83e6a137ca6c919f7859e2366ca29a0809cadeb4026dab83506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5305613482626e39425225348e291dbfc193e0c04381dcf3373884d3e112eb16"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ossf/scorecard/v4/pkg.gitVersion=#{version}
      -X github.com/ossf/scorecard/v4/pkg.gitCommit=#{Utils.git_head}
      -X github.com/ossf/scorecard/v4/pkg.gitTreeState=clean
      -X github.com/ossf/scorecard/v4/pkg.buildDate=#{time.iso8601}
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

    assert_match version.to_s, shell_output("#{bin}/scorecard version")
  end
end
