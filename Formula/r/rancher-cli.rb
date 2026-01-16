class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "e6893558d3168007e504e19977ec4c7e6cf58beb6c864214911b97a344b5e978"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae6472a611147be8c3e6604358082b77ac363bbe295140f05bbf3f37196d5c8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd4dca5ce9053229492f01df52ac90fc6a16937e91018e0a988861a05865e6b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "183806c3c5f0974d8a009bcb2fd2272242288266d240c7238876a5532f29b01b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad28c818048573b0b7bd1ec264e9dd58b5e3bf7db9fe4ac8ae9fb8f575ecb5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe160b9fe6e257ecbd17d6dbdee630017feb8ab916e1ac2225ca85036f26ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b68a9824ccd9f1458dba3500509040842d4acdca2eef0666b67a630c700ad8c"
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
