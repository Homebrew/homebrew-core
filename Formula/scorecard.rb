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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b2c553f18537bec1869dde2e2e8570d3c19b32543d23f32f36ebb391999967"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f772131c54f876bb41e41caf52b8b67fd392721030b4759298aa9238687a89"
    sha256 cellar: :any_skip_relocation, monterey:       "4cdbf8218c6a4bb96dc28f2a7acfc0116fa86672f192b9f4b6dc8c93297e1319"
    sha256 cellar: :any_skip_relocation, big_sur:        "c11465a47d844bbc30dd871d8e203d9a3a8ff6f35be40dad573c2e10314d396a"
    sha256 cellar: :any_skip_relocation, catalina:       "22214695e0531517ab61cea7234565386e77a24055d5b3edd9b965c203a70ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd98b5c7fc164b8e31701dc27500f2e925f13e32f61287d7c0485bdf1ae91872"
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
