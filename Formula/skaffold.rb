class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.17.0",
      revision: "ad9c4899cf485f6931cb9de2ac3419b83081f73d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac4cf5be3c7b5119ff0d85f9e1ef1daeccaf4adb07dee82c8258df3ee484e0c7" => :big_sur
    sha256 "ac5fa32582326d2a6a9470515d9921bd7e88f29c07bb37ab832ea46d98400fe4" => :catalina
    sha256 "8c5d7501b8ffc74e11b32983f7bcf36b0717cad26f3ac00b272c9392c04fcfff" => :mojave
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
