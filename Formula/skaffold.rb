class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.37.1",
      revision: "0c33da624a8dc2c8539f4abdda631acf0ce5c1e0"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ef61316e015cab0c8944025e34c92cf6c8fc03069e3fa3e5bcdb3f4c68da338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7d21655afaf450ca64e515c13c081ce89b5bfc315d1671714487127ba85c652"
    sha256 cellar: :any_skip_relocation, monterey:       "7d6ef4ae4bbde0a72e670a3ec246946c5c8cb3dbc3f901604e3b527ad09705df"
    sha256 cellar: :any_skip_relocation, big_sur:        "e15e58c39e7190e05c5dff1a1e617673360416c2dbf5c320d1b18cac13b2a87c"
    sha256 cellar: :any_skip_relocation, catalina:       "dea233fc260993d186abfebea22cbc5985d87daef0e77b9d84aed6b2599b3403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd8ee2b07612653330e87c8aca9d8332a0b1fb2b40ed211c5c836db02d57086"
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
