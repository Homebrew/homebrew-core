class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.34.tar.gz"
  sha256 "0dc8152a9be87f1998f8c08ee075c9ba51c6fc1770a1ab32f0b5113ed3433267"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42edf7732830824099e8a32c3f6038336e511742d5b51edee4dc9abbeae3cbca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28ed7e9cac7095d76152d2b3a50c2d5b5016a391d526c0414beee0e3ecb68711"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59bcf4b3a23172a10b0be5d4ee4bfef58f6636a076d88e97bbc14e4db34cb97b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e65e4fadaaf261f7fa99b7a42a1cccb7d84f62af2386c0a6d4f06b090dcda980"
    sha256 cellar: :any_skip_relocation, ventura:        "56c87edbfbece874d0f70f9ccd5063d3e4e27c904033c45789f4a119175eb376"
    sha256 cellar: :any_skip_relocation, monterey:       "1912ccd787e75df01a05181d4b7adf08c20a9493a80a5f7a398c19a453278508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19694b94deaa682218d8bd26033c77b9da23655f350ef0f3e11447e951d7df7d"
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
