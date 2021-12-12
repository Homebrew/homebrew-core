class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.35.1",
      revision: "6945c5b1cfcffc4a168f26673c0f6695f2088dd2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d73d26c1bc6a379ad834917999268ca90cc075eaee8e072a94866e84d456a3e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "158d73af08537851a832e034efef6743c6b794a04ac8ee974bc3aef855267de8"
    sha256 cellar: :any_skip_relocation, monterey:       "89eb5f5b3e7c7ea01c3c5c651aa4fcbd1c99622798d061e67d7a1b2e0136631c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d526dc68c5c92ba878f1da1463bf9e40f5adaf8c30afbfda8d8463f69e058700"
    sha256 cellar: :any_skip_relocation, catalina:       "7e9cfc16e803f677c5205f1200d05130eba30d11b77f51013a4ef4d6ecaed0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2344704a916ed263acbe9a79b3e0c29d01d15a494511cdda67aff8a2fc57e7c0"
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
