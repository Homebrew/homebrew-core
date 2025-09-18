class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "238ca8a3a4a07a27bdb0ef7d6268da5e46474983d5ad69e3f8304f08c565f63a"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "207f90bed9f4eb3156fee85c2eb3c1a24eb84fad1bb4c63689c97a76fda45257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f6979d7158ae09ad20e3789a0ad54b690661c5bc09b19f727ffe8dc0e90ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9052fa4656450bdf41d781cc076224891504c52f99f6fedf27554bab755f35ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c647ab6e8ce02e55b934f4f4ced219f83a9f9add41b12ff7f4ceb053f9f4e1cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "731f33721e65a19c9c455de294254e8323ef87b69e3de32b6a204420937dde0c"
    sha256 cellar: :any_skip_relocation, ventura:       "4086c9a1593766dd1f7cce464958f115342f37b300cbb68e2c6770cd80e09594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d07ffd88675b94efcb0a2f6cca9ed9934a2dd62c483909c7f852467c3c7eeb9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
