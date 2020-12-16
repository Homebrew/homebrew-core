class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.17.2",
      revision: "53e4063e12b41bc19c6cd3929d939f17ad2e88de"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c3bed94b02b9ab1a8218db62154f69d779475e15a7961b1ae90870c7bbd395a" => :big_sur
    sha256 "cf1f406c9f1a6c0d16fcb87ce35f0c012f9e9ee0bf430e5fb321c8f60d42db7a" => :catalina
    sha256 "80c54de785afe4a20bde82af3e2e1e4eefe932cd082ad3732a2c8123b9d6e3e9" => :mojave
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
