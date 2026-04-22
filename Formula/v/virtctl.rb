class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "803ed14a76309113ceeaa116c061c63a4b29827fc44bee7a35dd41c66ffe7a63"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca7784d238e5914d2c84a66c2bcda5d27d3b79a0995c8cb15d8bbf4a6e47080c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3c16ea80f0d3199363559c13a6b404c51596a768ec48b85109ed1a53fd3524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae03467122b703521e81bb92d4bc97299cfa62d12e36cf29d7448b39dfbeb9df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1de0f619a63f1585b184895b4e8147f7da65c5a06a10796eacd7c37e3ff0fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae62c2ecdbf4ee8a9b136c2ded316448db597af2f5d743138d6bd9a95c7b718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b606686b74ca4161c9e2569d93e5836bcdc5fcbfe5f13c27278157596e9ab4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
