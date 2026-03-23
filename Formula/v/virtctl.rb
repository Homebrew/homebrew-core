class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5864123d569c749db0b2bad9a4b014e30bcffac89076c4e99165b388929eb1ce"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3632ac4486e0324ccf473d662d5d220f8c0954303d70a4e2db3829c373f2ed81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d576e0386be95d424b3eac6a2d0d12d7ebeb3738c911e05f4eaa667c6228d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36ff1887059ef066edb0f2d45465f32169ade7d0ca9bf5e6c0d75c7587d175b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c7bf9b81da67be9a83291931c6c6d5b99b57b19299dbc624af1994562a0cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c282a0bba6503c958d327e825864622b39d49bbd6a6bd2e410a615dbc5d434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a996acc752326048b344828c76e30cabd18378661f39313495e4a817e84da6"
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
