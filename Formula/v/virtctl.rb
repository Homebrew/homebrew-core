class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "5d2998666ce522d18dd157800cea22bbb15a2fbadc6e2130864ba869b2259588"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca4128b601a6641b1db2ea4775d99d43c694e7abf6380619ddf99e5b0d048a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55558b1368d86f1cdaa7464f5e3e01fc52c7ea95c218e39aa9182435086713d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c02df8e40f8ef7a670cd3731c368eaf9e2a4f0503576a78a13497610cf0631"
    sha256 cellar: :any_skip_relocation, sonoma:        "38946b3b212780ff1144f5254c6408d5d95319404aab23fdc7d790eb0ad0d643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "172826a9372bd9e8f4f5eb198b0c92f308161930080e913e9573bd2ab89d9f88"
    sha256 cellar: :any,                 x86_64_linux:  "e34725c0d1bea19b86ad47b80aaadbec906bbfdf0c80a93d3d8a68a97c133128"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
