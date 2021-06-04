class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.25.0",
      revision: "c788c2b15fc3b3a002edcff25b5ef33563d5bb9c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c576cb42da81301818117430b886c98ef7b5a82438cbeb5a0e92c46085e734c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4472bdd350046b588adbc2a9db6e2bc9a1e869950235620b63213eaa2ac0e6df"
    sha256 cellar: :any_skip_relocation, catalina:      "664520cd6fbe309fb552841303364b3577d36dde3e83625f9720b92f264cacc2"
    sha256 cellar: :any_skip_relocation, mojave:        "09bb5c79e2009da7bc53e88fa90679f7a1eee5684c25464265aa751d07d8eb09"
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
