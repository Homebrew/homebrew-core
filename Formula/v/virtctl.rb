class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7db46d96c35e0ab8c8e9e4b272daa87f94735ad6318a0019fe6bec705472f8ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f484e6a82c9bbd81839c90fa58dd901da2eef1de31b3c466555606ec8f8f80a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e01eea5f6575b21f11425c12e3538563fa67d2b5ad56c587f11079ad10095222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed4d599be6b1b23d66338e492fe065e155605008f7cc5c57a1dc46c575efe66a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a716cd74d45ef8ce1f176aa43b1ce79211d6d6e8890eb433d7c9a137bc22e7c"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7c42336030531f46bc73512eaccec02f7f0a5ecbae2aec9a3df5cfa1b89145"
    sha256 cellar: :any_skip_relocation, monterey:       "398817725c186fa71b87dfd6f110410ec20cb2f1820cb25aaa453163af33f13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a98a9fcb2a2f95dd399c8f047a2bb037392148839d79b9eedd1c5a460a3813bb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'kubevirt.io/client-go/version.gitVersion=#{version}'"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm", 1)
  end
end
