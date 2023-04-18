class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "3b671ac7dca6a3edb820f55491b9b4976746ed094962eb10dfcf6e133e194603"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9219eae50b72d4c35f63d93b43694cbf9dca3dc1a1eec346b630149a4af0920e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e548c34abc811b1bdab02d9f0a30ef2cbc771389710b0fda89fc0369646c2fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48e7ea6da90df27ab14d123901b66454b8a053d183182cdcd6e1e91ce54c3565"
    sha256 cellar: :any_skip_relocation, ventura:        "ebac2965b624d541bcecb7c648e17d700ba11df469c3bd7aae25a96fad3dac63"
    sha256 cellar: :any_skip_relocation, monterey:       "4903f0688c23059a7afd84e7594a44ec4053bfb2f52060b73c1eb8bff94621c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "61b5fdf607828e3d222b8017ae4f3cff8631d60c5dc2ed5aa5ed2c4c06e4ee69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c241cf2a590ea46ce678ae65fcd52638df19bbb03ea5dcdfe2f963b9aad63628"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
