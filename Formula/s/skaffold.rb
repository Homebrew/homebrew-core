class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.7.0",
      revision: "a66f3fa441d2f5ad34db81bb65cc6dc9da818614"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca639816cf5428cec18fd6c2b1d71060c321731dedd902d00b3addaa77d09b77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08f2be771fca01d0f6b3678994ef8ef90322ba5bef1948007f223617bf68fa6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2ed8313d8b26c9613a8157b3db3c5968c3afc53abe698c5270f7a1e94a84edf"
    sha256 cellar: :any_skip_relocation, ventura:        "689a2eb1a0547ccc571bc35a4d2358dab47bbbc43df4370a686ebaef0be37fac"
    sha256 cellar: :any_skip_relocation, monterey:       "5523d9cfa95aad04b4950964ba62ba72ba275e5a6365ee45aef5a48504ec8d29"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e2aab3723d2b36e5f2fb3fc0f0506458de4006db68551b2830ebd5a779a743b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe4058e456e46a944154c142f8e40c1904d699f8fbf4bffe56d157b7a4689a7"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
