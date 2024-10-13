class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "15204eb744175429be2d8f646a5a598a8c743539d3337c61e9b51f57d98cdce9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f4dbd2788af079eb30fe06031c539daff0a4398484f0ff34a2a78bef6cd2e497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e9112993fdf92f3e543041245c24555e5dbd63ea83dad77b3034fed60e33208"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e9112993fdf92f3e543041245c24555e5dbd63ea83dad77b3034fed60e33208"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e9112993fdf92f3e543041245c24555e5dbd63ea83dad77b3034fed60e33208"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dc356a805bf1e2478a1c6abb814b274595112a8f9c1b23628ae41408a5dc03c"
    sha256 cellar: :any_skip_relocation, ventura:        "0dc356a805bf1e2478a1c6abb814b274595112a8f9c1b23628ae41408a5dc03c"
    sha256 cellar: :any_skip_relocation, monterey:       "0dc356a805bf1e2478a1c6abb814b274595112a8f9c1b23628ae41408a5dc03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285b0ad52e825fc1463df79499b9e6e6466a0dd24d477deaac1b89d2d22ad05a"
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
