class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.30.0",
      revision: "dd7e764da6f11eba1047e0773570c1a8c12ff160"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9131c2c6e450d6ac909e589ca397fc8e4173e999246d1f9c86d36b707ce85a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "9187a5a041f63d418fc4e1dc76a032afc163d764b502aaf36d872b84d67c7d31"
    sha256 cellar: :any_skip_relocation, catalina:      "ad802d83e992dfd751ea59c49cba4863473fd7d8c141a15e78c8515fea11cac4"
    sha256 cellar: :any_skip_relocation, mojave:        "1ebf8c889ff1c17fb2e634cd76f86a227cd879144240ddd0f0edad9d9165908c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9635093c1f3d31a02ef1eb807578be5e19e94d04e8d4468a308d3a149edb467b"
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
