class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.26.1",
      revision: "438dae66fbf35a1c9ee23f21a6f6e8d991c3edc6"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7566111ef2db7367e11b6810d11e38c0f93047a703bdd84f4f45c566cc3b9435"
    sha256 cellar: :any_skip_relocation, big_sur:       "75d176a1c964392659e698079ce98d4aef8bbfd1021fba53d474d37faf0734ca"
    sha256 cellar: :any_skip_relocation, catalina:      "843793b86b449821cc549c6d34570e2621659b12bd957c0627ee02ae8103bf29"
    sha256 cellar: :any_skip_relocation, mojave:        "f69975915448eb510495ca893b32a248211ebde8fa86f626099f421d510bdcaa"
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
