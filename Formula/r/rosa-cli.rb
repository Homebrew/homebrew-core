class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.28.tar.gz"
  sha256 "d652c2c85c8982463c61c50bdc9fce0711517c5be4350598a16fdd0fdc5c6125"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef25819a937be2fa4446e951827060cc1b8cb747a6d0a773792390d5641646b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0e85c7276fe5bfd67de6fcde5bf3fddf3ead1db0738f2e52f46bb1ae642707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "decc988858f291fb1834378d5d835de903a9caa0f001272e82c714cc2b588e3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "01b3e3284341b563ee30d5bfd9d934437103128dfe12b56b9eadc477cd6db591"
    sha256 cellar: :any_skip_relocation, ventura:        "451919ca028756c37b9a84f87f52665df06c2a7e3ef9e7265d689360bb87b577"
    sha256 cellar: :any_skip_relocation, monterey:       "9627006f92f2b2184e6a4b895c388bede603021d8d6c344daff38d02c22048f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7f40890a7ea8a7e2dacaef6d5d8287131a1c78b74ace3201c6c85c24286475"
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
