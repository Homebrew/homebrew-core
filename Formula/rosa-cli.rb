class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "8bf81ca69d57f2f2c21cc385cdcb49ccdb92ca276c4930ee31e9da0a9ece1823"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f9eec0fabbec03ec4a573e322d46d343b61dd0995beb71117b95224d730cd84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddad2bef49aba32e30c9307801d1d4f1c5941ebd242556a9b2374f620a870071"
    sha256 cellar: :any_skip_relocation, monterey:       "3c15f7befa8c00c86ae4012e4ebade0a75ec68130c5d90a0aff482ed1eb3420d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ca8a02585cd8d5dba61c61108c409c6610edea79ba73286ea8fdea26617386b"
    sha256 cellar: :any_skip_relocation, catalina:       "8ae91dafe614e5ad9e32e623f48c2dde7e735a4f1847b6718ed71e60ddeccc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9873b5333b648a4ce6d3276440cc56b122677dcc810d4e72b452d73b98baef"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args, "-o", bin/"rosa", "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
