class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "003b8aaf5d87f92f7a49bb51e3a1ee44a7fbe7aca10fd9b165bc8b79fe91f52e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc4a56033d0adccf05a78db34b863fb7156c8f5024b585a31e8e8da93f3ceaba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc4a56033d0adccf05a78db34b863fb7156c8f5024b585a31e8e8da93f3ceaba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc4a56033d0adccf05a78db34b863fb7156c8f5024b585a31e8e8da93f3ceaba"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5eb0c28d110befc9a5f228390b5bafbe20f469c3df5968be98a8a89aa9894f0"
    sha256 cellar: :any_skip_relocation, ventura:       "a5eb0c28d110befc9a5f228390b5bafbe20f469c3df5968be98a8a89aa9894f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5010b9ecdeea1508663b2b8e7c6e995785a56d6db2874960c444863965d7411c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
