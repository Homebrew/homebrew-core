class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "be69c1d91c4534e0391f4101f2eedc4dc6c0b30569d9d60a6569033f5edd8465"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef9a9acd294de1dc3153b8763f0383b2f93bbaf067db52744b37b6dec048c773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9a9acd294de1dc3153b8763f0383b2f93bbaf067db52744b37b6dec048c773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9a9acd294de1dc3153b8763f0383b2f93bbaf067db52744b37b6dec048c773"
    sha256 cellar: :any_skip_relocation, sonoma:        "acb70b3c204315e3b8f0e6a143e3ca56a1fd6cb809e83057fbdc1de33afe9c9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a06c8fc127a7662396ccf46d9c4f0ccdf0dd08bebb43c740283d9e0aa745482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68eb00732fb622f92e72c51b2f8f86bfc07693f80ed87f0173d35fdccd7c70ee"
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
