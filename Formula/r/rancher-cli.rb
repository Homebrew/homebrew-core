class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "2d2b134fdf8ce3871b1eed94ef9b15757741f1e5351640e71e5c8455d5c2fa27"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d19498f5fbf9d6da4751b053053f32b0c571c3ad97269c508f164e6c7bac812e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f058c0428ebb65b21bddb16827e1e5adc3bcdf6e242b5b0bc4ae3732a29dc17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dc3e647e882f404c8d4f97bc18d80696f5d68b010d6df9b75f2ebe5551b6c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c365c63cb1da6c58c481fb1072a2ffc60af8b7b157a96d8b8584e49213ca476d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "881f2c3eb390c3d44382bb88bca1b41d1cc313b18a817748a14357bb0e7b2533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620509749bd540523b51029db60bdc48256c17babda4b4ab8765f705cbe1287f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
