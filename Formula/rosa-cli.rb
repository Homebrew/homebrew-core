class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "6bcae60229afec1c6a02217fb69f503ea437515b560ac87e2652db0ebcc1ec6d"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec914562a9f7d06a8f9802f3c1aea14aa22bd57dd1a75ff2cbe85c8b465d12c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80510e3566e45c0d3570d3451224b9449fb35dca8656d468e094cee14c76b3cd"
    sha256 cellar: :any_skip_relocation, monterey:       "65553fd35559aaeb43eb767b65ae3cb0031a0ba86754646ad904031b214e35d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c76089d7cd548b544025ed140af232a2a792c7ee0ac7c682fc2bf9d26f916fff"
    sha256 cellar: :any_skip_relocation, catalina:       "f38c214a778e844dcaba1c94ff53cdca9743bf8fc683dce946a0ce01d6bbd5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06cc98831153a7ff2fbd789145d0e316f5b2e31fc7a75cbbef1d415f075e293c"
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
