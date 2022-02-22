class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v4.1.0.tar.gz"
  sha256 "c460ae4cf019dbf7a582c353cf052f14524f187e9fab76132a1af1d674ef8613"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b98516e75752ae178b4061068445d2aaad68a4ff2ac390be3eea72d6cfd21d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b65bd5ac96dd6d7ead8330f8aa34d92c81aaf35f7ff19ad9be9aa71bdc0ded09"
    sha256 cellar: :any_skip_relocation, monterey:       "4a7b05b4f0b1b7797a09354c073bf1ccd100dd18a1119f80df48dce934e13af1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f2703873320ed11163debe4e6cf4c79b0dae688ef718a5d745559ca52b33a8e"
    sha256 cellar: :any_skip_relocation, catalina:       "5308bd0ea17f06a639a45dc50e0c0bbe49c008551d68ad0174b5af7149b6a449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da94f514cf0b0f834d25d27ae2503e8e69633dcf18637b5b8cf78851bd767ab"
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
