class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.33.1",
      revision: "ec522e6182dbe55193e29b475cfe6244e621a140"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f34d7f1555ef8b22c3d309d4fc5c0e5ad74167d89965f01bb42109ccdd13a9f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53b00760b3a162522641ff54d2d315f891c2a5937369da890fdd20955957bb44"
    sha256 cellar: :any_skip_relocation, monterey:       "78cfb658f61e5427581cc67ba75ece491c0d9e2c6fd97bac1f4eb47afc6e5e19"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9962183e666d6a203bbeda4dac92df2c8d61f7a2e225c3f8ee6569aee642fca"
    sha256 cellar: :any_skip_relocation, catalina:       "01f1b1fe75ea333235f0ef0be9fbf27ed36498bf11c4a1251d94e3a75193c230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5d817654d5395fca23e29f2c40ea9e8888cbc8bb83c4282576d11b068fdf0a"
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
