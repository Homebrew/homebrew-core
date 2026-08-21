class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "7250afa231aa6e6e80b1714fad98592d3dbe4e9261d7c16e19889f3681ced705"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd0df1cec672be902c248c82c2b9dc9768838485ca0f1c2cfec73b4a769b85ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c0cc5f36bb2540efc4df3af7f09f9d4319ad7d5805826f8bfb1261e4be18d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662ce1d543f45e8b45783ed863169408aa4665cc3dd9fef443d08b4bc799287c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b532aced258842cdf529e46d793a4449b0734733ccbef4910e7f2f71da5d0fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d09ea024b1ce5268e8f837ac962a166c60d90180171f77c98d37fd5fc7e4461f"
    sha256 cellar: :any,                 x86_64_linux:  "69085b94c3785d6a329badad227fc57380c5c16a130049f87d3e755201e7f707"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
