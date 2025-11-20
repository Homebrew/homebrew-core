class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.12.3.tar.gz"
  sha256 "50d808e7990b8f026795c1f8fc7227ca357c1c447becb77869348e3ec3ad2512"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9246b2c7e4905ac97f0c90deca02fcca7b7d500d2bcbb033bee1e2cddda4dc1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac501066a058031fecdf5e2c5c2764fef50ddc0f8d05b6d71137849578e9e871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6df7b1c41e8f7a4dffd8cd708500ef3bed57c03d9072a79517acd8554b8bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef234b5728ae5d2b92e8b371c1c261360e01227885648f03b56de79eed7c1cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6fd046006bb1b66f1b67278c2771597a8e3498d2259b26e4a1d65f71b42576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2430b4569284d402fd0faa6a0516fddadee1f6f35399d4040809cb6a3145615b"
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
