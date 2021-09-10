class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v2.2.3.tar.gz"
  sha256 "4d67321b4cfffd177c3be140b6db058c716a77c433f0cfb590a0f4b4505ca34a"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5da415011016cfb91dc1a79b88084816c39587f4fb4a13f5114ac9eb785e02c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2ccd6165992021a8112c06e6279508e987a0c2fd10fb5cd37c25bcbb1100ae4"
    sha256 cellar: :any_skip_relocation, catalina:      "839b5e8df85392171efe2977fcebfdcf61b808160f5b44731a7d767cb6c9f621"
    sha256 cellar: :any_skip_relocation, mojave:        "d3a252430c02e42ca2efa3011e367e3013911a33c43bab6257db112aeb3987b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/generate") { system "go", "run", "main.go" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    assert_match "GET https://api.github.com/repos/kubernetes/kubernetes: 401 Bad credentials", output
  end
end
