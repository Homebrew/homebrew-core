class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.40.tar.gz"
  sha256 "c486b192a97f95aeb6a4559eaf7438b2876342620222b5199b0b638601d139f9"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae544ee94f36980d1a76fadc38d4715fd956f1aeb916748211d68534fb21c959"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4974d9920b02b74d6f5915c2020c0f3c04695d7ce2f682701670d8137281327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e75dfa03d613a5348f8ef85bab08772474ab057641a324e80d88636a2f50eca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "349a4f1e641d399528515997817c5da3127a90de9dcb31d73a5bc657ceb05108"
    sha256 cellar: :any_skip_relocation, ventura:        "6b9c942d8e7cdd45f6e3b14340d72ecab36764be0a11f34101bc571a7593bcd9"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae94e4a64487fa4d64cd0e0d70458ac5ed1996f437447790cb1c615afecc9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838e8873c9248f729ded555163f32d8ba1d9d4e8a824dc8c86758ebd37932bbb"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
