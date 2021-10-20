class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.33.0",
      revision: "251c0406b3f9ef149cfa084d912874fd080e1e97"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f2455f7f099dae1bf83a163b7e856f257b26a74d5c2b13044b082c702161288"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d9b4729d15d2fab7c71c7849cf08ec7e4ff0ad3a731a89abff659b217ae271f"
    sha256 cellar: :any_skip_relocation, catalina:      "73fb0cceba81f9a6a0661e3212f4612eec246314c295d72da7b50a3f09fafec3"
    sha256 cellar: :any_skip_relocation, mojave:        "bed6d3a0c299e93436cc8aaa93da15484e76a1514bb555fe9eab46ebf51af604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123d9e087ce93d4f6287ad33684d70e9bfa6d0ceecab189d49bcfa4ff9ec3376"
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
