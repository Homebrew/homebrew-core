class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.14.0",
      revision: "4b3ca59af505c4ab5d5b6960a194e1f6887018f8"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0b6dcf8624ae1b40804fd9bcd85521034fafc247816c7f4f0944593ccc39c7f" => :catalina
    sha256 "91aae75e46412a2251fb59a46952258fbfe79970b0549345455a8f060c6c9ecb" => :mojave
    sha256 "9a1d81012e59ab17591f1b0a0b4cd9ff5ff0a0043245bccace3e17eb42a6e6a4" => :high_sierra
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
