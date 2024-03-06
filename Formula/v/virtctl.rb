class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "da63ee052939a68e54dca37084234ebd7a86233f2087bc13cb7d63fc24d356e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9f0346de82d52158d7d88e64f2b2cf69557e40fb97d0b2dfb1d5d1c86582c49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b5b9acaaae156bb4c1d218baea69d2a90bd26eb6c5d3ffade011208234e7544"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12dd29463f27dc38ff7e4d2cad66e788dcc1053d50ee1b298e1dac9fcb9bbd4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d68b7a3ed59c4815c402ff8a55ca103220647bffd7cc9a8d355c7bb6a36b5a33"
    sha256 cellar: :any_skip_relocation, ventura:        "d36097117b1058d0d47329d8ee1106c64e759d5c3337411e5162119945472b52"
    sha256 cellar: :any_skip_relocation, monterey:       "c296845e2bc7f1b442407d3d264899363357a17fe826a438a4a11760d411a96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b72d7ab21fdf8eca2ce760d14441b67f5df33c6b7f972a023bba1b8636075f5e"
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
