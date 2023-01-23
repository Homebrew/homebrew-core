class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.1.0",
      revision: "6bc234c39aa541f1ca4bedd56eda77e7f7456b6e"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c655bbd1223469fd659086b7eb7b9e0a6a8135cc645847b52d5e1c366f557c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8a70416ce3d04de837faaf3c41e652e9e0a62adb4fb7d0d508a7dfe87fc4780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13477b93f800042a2c6b12f60d300afc5cb715c6eac2f5786d9290949041ada5"
    sha256 cellar: :any_skip_relocation, ventura:        "8f82e2773f3990e6926e4189b83a7f12a9351235961ebd53ce6d306aa06a02c9"
    sha256 cellar: :any_skip_relocation, monterey:       "922b76a8e75ccefd64c07049157901be46bfc404842e1ef01fa5c56242eaa8f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c0111fbae798d51dfe5363ec71b5828ade9ee1a8e525d8d6ae1b56f98be4244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e57c02b989e358c09021f1b5cfce412f9ecdaeb9a743d3e19c8d22b327c61fa7"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
