class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v3.0.1.tar.gz"
  sha256 "81c534c9bf5237c48060f35f3536ea928e9248e504b84ec090ff5c3142c7a7ce"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75c0d43bdd888c815a26f7f2c46c4cbf325dc45efe9a4947335507f14ae9d84d"
    sha256 cellar: :any_skip_relocation, big_sur:       "61e985e1b6b9dc32a3788e139a07ee430e06c488eb27bf046c672d13c4f898b6"
    sha256 cellar: :any_skip_relocation, catalina:      "65026697be3368d7f33d7e0ef64914f41be7ee417bc1487ea15daf202954ddea"
    sha256 cellar: :any_skip_relocation, mojave:        "ec3fc7fe857a9717530fd71c0f8e492780a3fef14108bba27b0dcde590209c4f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/internal/generate") { system "go", "run", "main.go", "../../checks.md" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    assert_match "GET https://api.github.com/repos/kubernetes/kubernetes: 401 Bad credentials", output
  end
end
