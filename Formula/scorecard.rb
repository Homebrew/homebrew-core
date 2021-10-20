class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v3.0.1.tar.gz"
  sha256 "81c534c9bf5237c48060f35f3536ea928e9248e504b84ec090ff5c3142c7a7ce"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b7ba6bcd3461066e2cfd4d081b003ef1e7bb79f7831a36aeb62dd932c1cdc34"
    sha256 cellar: :any_skip_relocation, big_sur:       "cff726899d5c3cb9b91adac809205a522e60bbb5542f9d791b9d5f361147285a"
    sha256 cellar: :any_skip_relocation, catalina:      "5a805fa1eecc36a61cba9787b71ddb88057f68874c5be597b2eb2b25bef5628e"
    sha256 cellar: :any_skip_relocation, mojave:        "cfb3a6b976347a043714fe6955bab0da7272b9a106959074dba960747e74a860"
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
