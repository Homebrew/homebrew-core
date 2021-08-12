class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.29.0",
      revision: "39371bb996a3c39c3d4fa8749cabe173c5f45b3a"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2be733b486b8ef6451f447bb123d9012c0ba91aca8542f30fcccfc0994ea6133"
    sha256 cellar: :any_skip_relocation, big_sur:       "01a2dddafba4796d84315afa5515fd348d3a3d94b944b85c800f4ab2fd7ac180"
    sha256 cellar: :any_skip_relocation, catalina:      "84a31133c0b2bbb85eb84547c72fc5bce763ebebe7c38c4c2e52bc38fb665bd5"
    sha256 cellar: :any_skip_relocation, mojave:        "893245b035ca0db7fb10cc31b85cc1d68cf04a124a85e28603b13f0a2c5ed47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec322f17bcf5768ae43178cf946ba98c7ca58eb8f5c55e098950928d1865537"
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
