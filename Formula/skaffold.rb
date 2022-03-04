class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.36.1",
      revision: "189a55291c18ac850277134d2b8f3eaa2c4f7a1d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  # This uses the `GithubLatest` strategy to work around an old `v2.2.3` tag
  # that is always seen as newer than the latest version. If Skaffold ever
  # reaches version 2.2.3, we can switch back to the `Git` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7483c78a9adbacd146d8cc962c6252fcb950a30b69ef118cb6a3a61a2c1ec4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4edc59e15b3ff5caffe62e9777ff3408df4b603fb99723a0a971802fbb43fa46"
    sha256 cellar: :any_skip_relocation, monterey:       "31c5b2bd9b914423c3f9f9be07fb07c52c0f40a15321290b5888541951cb32b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "143fbcdb66b4a87ce02d12c7f053fbd3808b2c2b33eafa1e652fa8be6101cf46"
    sha256 cellar: :any_skip_relocation, catalina:       "e7f6f99de9e79aa880d19ecfe92024ec3ec21a10e9fcf187b5c99ee6ab009616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9024fb72316ddb2ce768f92436ab0502fae31c9c2920e16deb6f6717b10f32"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
