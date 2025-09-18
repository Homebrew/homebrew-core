class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.56.tar.gz"
  sha256 "64e00ca48237983a880a358efcdb4939507230e8072e71aeb0ac6deb97aa409e"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a352224af7a427ba96ee1a3ce08cfe1b6a83120a132f9b5926a427d9079acf8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e9995651c600c579ccee2ba7ed46c5b66616f7bb79a94312d3c28519bbb100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a43afc197277a823ad55111cb517f12f62acb91cf585516c8343b5bffa691bfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6c9a0fbaacb864d4138c996f56e87ef5fce4141de5b121060e48e313a6e89dd"
    sha256 cellar: :any_skip_relocation, ventura:       "09bb6abcb8876f61ee2cab7d35f5e93a87e0747f4c2ceeaa33686362e281ea96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de6ff3e095a30e6ba5c6e231c167c71ce090c44f9c518d17cc85ef5841553ed8"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
