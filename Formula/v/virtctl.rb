class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "5bfd1d3490b1abb0e9dfe43d4f7034f8e8e8a97cdc0889b8abf396a0fb77ee35"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad7b6dfd0af8fd435eaf0a65e41ea236dea496c6ba68940d6caa840c26964a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9aed86129edd71aa5ccb2ee8fdfdaf19d1dff36fdbc43f21ca01907e3dd8bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87729350436c0b40d41bc81d551bbe10ec91ff7f9b191e5ff9502e9ec136b0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5faa68f59f7e6084c7011df10acd302ec7da431f0ec2fdc7139fc4ebea4d098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6bbf5f5a6dc8fb743a88c3be74fc22030bca0020d00f4c0e2ec780a5b6e1c94"
    sha256 cellar: :any,                 x86_64_linux:  "86f7338ccb31e2e6d62eb313f8d388f253786464ce68a14b9f1787ac25641958"
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
