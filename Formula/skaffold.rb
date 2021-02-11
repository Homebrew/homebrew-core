class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.20.0",
      revision: "c48e97690d8daffd68141c2a68fcbe3df6f6936a"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6a2e3132618a244a4804b6bdd209f7a08dece9d8afaa0881e2d217849fbfc12"
    sha256 cellar: :any_skip_relocation, big_sur:       "5800b9e39e18c482c85f5048e585c4092f6a7d4b39412f1bf8028d89549fc902"
    sha256 cellar: :any_skip_relocation, catalina:      "2d0cad59c7d7374b9f95c98db3a7d7473e66e80c77af843200c0129956a3e044"
    sha256 cellar: :any_skip_relocation, mojave:        "426d2e47d67860106cc513866857af31a4beef787b092d01dcf06641c510db6b"
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
