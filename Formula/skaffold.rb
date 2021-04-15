class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.22.0",
      revision: "4e67ac7be12926c9714c48b4bd2b3562c6e1511b"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "737387a6d92c5aa645284baf7f58a13eb634d6bbeb9166b90eddc187e9f7078c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a5001d39658eaea5ab584b5403d913e62988bc3ca37f529797c0878444e841b"
    sha256 cellar: :any_skip_relocation, catalina:      "de19729af05aa3769deca70e768879e09657914a7c05c1f1c17a6314fb9cc257"
    sha256 cellar: :any_skip_relocation, mojave:        "6e97ecfd83dcfab457a4c9ff376b59414d7c8da9df0eb37c7674e57e17c74662"
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
