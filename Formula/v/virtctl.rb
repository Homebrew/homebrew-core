class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "71bc21163ada3e39c55c19f88c057ad0194e97043441d471f2bfd51782550a2f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2142ce8cc310b1054fc16895251defd48bfc4a9b5ced1159a0163f8e489e7fc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42573fe8fe2ea4be5276e00a188bd5b71473ddb157904adf13696bf16f7bd963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6fc68c13ab187a9b86847a60e53d592f796d4f7c2ee340e0f18eca03ff64a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2257d8ac380af04a605d66f0c751590ff27bd2ed8de88ba669b76cfa08a2c10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c7ec59a78af5497b158db2b12fc822a9a5e6afa14ff5c0cd282ce8ccd31078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a587dbc3ab8ae1678c880b31b71c7891643bc42061d99322bae7750b22cab2"
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
