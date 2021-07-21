class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.28.1",
      revision: "7b855e136dc0f9cc5544ed2808c9d5feb767118c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91e8bce48a3314be6b81f6fb3ed0f6235821b51690292846f67c9e5a00637a5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "97dd7968a9729f3438ef0cbc0da7e73bb128efe1c3ea24bb9c10e907dc8a06c7"
    sha256 cellar: :any_skip_relocation, catalina:      "bd68f29ec61c4e6f33007dec454b5613157d968af02b2a27b2f8a3a2f7b4d50e"
    sha256 cellar: :any_skip_relocation, mojave:        "f7ae59949b59e571a7d47dd89539a9c2fdea0387ecf8636767f99949a846207f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467c5c29ef54a2d6e2f81b23ef873eb066f41f2c0e318c8bcc39af654f1ae4ea"
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
