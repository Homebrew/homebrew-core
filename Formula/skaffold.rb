class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.18.0",
      revision: "efd0c52a28caa21bdc3e3f9ce3bbc18c42c94418"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72d6ccc6b8d7877bf9046386706ddbdd4883a415a625a909be05857b23c994a3" => :big_sur
    sha256 "0f1d4988b8f22f48f520a7bcb7c8276af693b3e4727e567a848857437f4dae64" => :arm64_big_sur
    sha256 "01c330ef0021dfb69be4b28800b78c6cb5032c00a40250e6ff2d07dfcba3e55c" => :catalina
    sha256 "b0cda5ae4c94e4f8e237e2198ecf963025cac09c96314dd833d2b1d90a9c33d8" => :mojave
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
