class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "48319a2741c4533233bbf2e5a71f1f05f32c0e29634e2f6cfc1acfcc66745c64"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83790cbd649166f0b498f1dbc8f8d1c8f4ffcd2f966d8374d34e8fca311f4a68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20cb240f8dec0a5b643373bc3a29760fdc33fc16d893d0723ba2bc1888fce3a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c7cc6c816116b7f9d158c3518728e91214f44fd9253f1732b53f41a0f6cb608"
    sha256 cellar: :any_skip_relocation, sonoma:         "166270bfca65a629b4029f0a1a70aa75a904599d0efe3a30305eed349df44a79"
    sha256 cellar: :any_skip_relocation, ventura:        "2db816ac75d762fd649826e2d8e42e6046908aa667317e2ff57bee2c6a32a723"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a836665317a47670aeee229d02d0a63ef1f1512e9ba3bf4eb31b7f80415ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa0c68af0007dd06f783c222e47ea3579b40fa6352aadebbedda920fd4a460d"
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
