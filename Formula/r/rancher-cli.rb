class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "6c36bdc3ae3158fc8d630382ec2d1c4542903224da5bd033f10ff1aff709c84b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dda5aade181fd43138ea6bcbc5987e75ab637ad8062ec21ce9f32df339f4db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e246db00df06c739f6692308e53c7bf8945e04ef2be2d2be03a289d0e24c801d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55b4e9b6bbbe8085ea0fbacf5077231a7a807f19d8ed79959e65eea44970723"
    sha256 cellar: :any_skip_relocation, sonoma:        "634c3cb5f3f9d7ac5cb7c8536387fd05c33d21ec2a7e65e4a1ae92b2021aefb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "503adf0703dfab77dff05f6b06d3114af95fcee0eee118dcf75fb33c265127d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd0f9d9aec7c26f4cb57393b825df625ad74100ae3f711c605fe8102596395d"
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
