class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v3.1.1.tar.gz"
  sha256 "94a471ce9002fce392c9b42d0678d6cddf7fb90c4784de4cc8f51ba2b6798c04"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67f1def62e65bf47da099c34c763012deb959ac9997aba661143fa51bfed9e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b7ba6bcd3461066e2cfd4d081b003ef1e7bb79f7831a36aeb62dd932c1cdc34"
    sha256 cellar: :any_skip_relocation, monterey:       "422779582b4dc65b7a787d3b0816a9d9e1018bf982264615346ff858766e5525"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff726899d5c3cb9b91adac809205a522e60bbb5542f9d791b9d5f361147285a"
    sha256 cellar: :any_skip_relocation, catalina:       "5a805fa1eecc36a61cba9787b71ddb88057f68874c5be597b2eb2b25bef5628e"
    sha256 cellar: :any_skip_relocation, mojave:         "cfb3a6b976347a043714fe6955bab0da7272b9a106959074dba960747e74a860"
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
