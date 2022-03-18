class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.37.0",
      revision: "db0414e6646f54ce7d22a7eba65182c12284f162"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ba881d3e429dab74d1284c4def55093c382aceb221a9f7d5ada58d26074c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cfe25543feb08e02aabb29e3da0507fd452c53e879f3ab5275bb7bc7d203ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "381582a89e9dcfad88003904f1ee97e04004cfa2e790a9ad205bf42ae219ee16"
    sha256 cellar: :any_skip_relocation, big_sur:        "e725ed40eef956916491b268832ef3c1ec98a7b088d8f9d55e5545429728bc85"
    sha256 cellar: :any_skip_relocation, catalina:       "d0b3df3a2d486a0659b59524929c1f039d3399062a66bfeaac92262e3851b59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98b914ea8004c5e9c2d7be0222e90c27c1e00e055d5d519ab452556995b387b"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
