class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.31.0",
      revision: "e7ab8c9435fcd2c7f9ec6695d5bd76ce8ea26159"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3db66ec4350ee3321eeaadac348bf877780306fccc6dfdb59ce01afe8ca6df09"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1db78aa36390f3de9937fe04344bf8630c848652fcb9e113294126d4a423e14"
    sha256 cellar: :any_skip_relocation, catalina:      "6ded3cfd666f2a43a6f38e237aba39b14b10693de2bd8957a4b4198545be86ab"
    sha256 cellar: :any_skip_relocation, mojave:        "16cb0fbb751b5e0921f1b28258a54c89132cdaffa5f705b2bedd2e2150db3ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0368b41d4f60638f003bb592e19feaebeecf91990c37297318bc22ac305647fe"
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
