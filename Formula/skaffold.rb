class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.34.0",
      revision: "22cfab75ffb305e7af220910af2f48d0a5c0e6af"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce5210a0b7b3b7f050d38b3b0a2131484f9f3b9ce54573637849ec66fce7637"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7512451a114b89f07ae89c3c5a327e7c0ddda00044debe6d17a8ba3492806cd"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0906dce71d794807adf07b03cb0ed396d79dfa0d8db1de9db59ad0747f126f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9c6b9404e1030f1a98b86599ca21320e0e94a4dc0e79ff43d81c12b060556f9"
    sha256 cellar: :any_skip_relocation, catalina:       "4888860486c5349c35fb3da60907e0cb237c67f0e3f0d4dc3cc4fe6bee1eb2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcee0afcf9bef30c6298b264cae1a8dc53054f5ae30badf7eee5b4d5716781cb"
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
