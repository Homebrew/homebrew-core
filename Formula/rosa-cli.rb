class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "3266546d67209d5d8e43434fc7c5b6bf554d25d33050639ce3ff8486f37bf408"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19d71a487b02c1f460ca6e93367754ad37880d0611aec8cb6cefa52b2f6ff1d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d71a487b02c1f460ca6e93367754ad37880d0611aec8cb6cefa52b2f6ff1d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19d71a487b02c1f460ca6e93367754ad37880d0611aec8cb6cefa52b2f6ff1d6"
    sha256 cellar: :any_skip_relocation, ventura:        "d9c37ad925647298fcabe1a9725919c93cb8ed3482a14cc416465dc3d8d3f500"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c37ad925647298fcabe1a9725919c93cb8ed3482a14cc416465dc3d8d3f500"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9c37ad925647298fcabe1a9725919c93cb8ed3482a14cc416465dc3d8d3f500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a558b9cfdb223bb199102b551923712f2bc11c74a26e413443b687cbaf381cd6"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
