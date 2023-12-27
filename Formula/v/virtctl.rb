class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3f51390dfcd16de55ba9dd8eac6f587916fdccb979df71003bf26b00de3ee7c4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7244a06f5b58dccd1a50f7ef1a40faaad9c0c154252db70e4e449c8daf080db5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cc4947eeb652f5c698f9da5c8f16bfc8e2f79d0e48d5d0f9f01dfe773beee84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "533693718820493dd3d4ad700334809926afd2f52930f49ac1fbedb53979711e"
    sha256 cellar: :any_skip_relocation, sonoma:         "680a86752676450f59e05630e1aa691dcfa7bbfe19276cfb3543c82d60f78dc3"
    sha256 cellar: :any_skip_relocation, ventura:        "e09b84831c80217731b903c85b09e585943f558faab222e7892bfd215bec31e6"
    sha256 cellar: :any_skip_relocation, monterey:       "7a00fb6fbb3fa7bf649ee1f582bb626934d3c4d314f0d38383822bbc01dfe130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902dd2dfd7165ae38bbcab55a06d9cc5c765d2c4fec75a5d81cbbd338c5ff39e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'kubevirt.io/client-go/version.gitVersion=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm", 1)
  end
end
