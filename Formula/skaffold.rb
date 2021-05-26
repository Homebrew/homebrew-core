class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.25.0",
      revision: "c788c2b15fc3b3a002edcff25b5ef33563d5bb9c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00ee8a397961d4bd0864b87b770d73b37121b743b069cea832e1881804c828c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "ccb3bae8828e0210e9ea4b108a9cedfb0a515eb5bbc1d0a517197658f5fa5e1f"
    sha256 cellar: :any_skip_relocation, catalina:      "ac3ff38d017039cae6014c1e58d6577e126c2a79b86d9bd42766bfb27baf5e85"
    sha256 cellar: :any_skip_relocation, mojave:        "4a59a84b3ae0993234db2c438239c260e65ff41c0dbfe56643b6b1b5e267d204"
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
    assert_equal '{"dockerfiles":["Dockerfile"]}', output
  end
end
