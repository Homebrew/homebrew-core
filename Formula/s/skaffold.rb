class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.16.1",
      revision: "95fb592deb61a4e290edca4925bd7c9c2fa93f6c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da74805a5e0303550d1b4b9458909a0ceda5ef187e7655f349bfc6eb734a25cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f7153ad45855c062b85cdfb448ad8b91ffc93a9b6d46186781301dd95566a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d98bd0a90396c3601e76f6e3e11765536671ffd877fe8b8bb952f42deafa9d11"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ae70e14ccf3d0d5a56b41f1762f973b0f021cf5d0bfbd861caa2c82a030ed4"
    sha256 cellar: :any_skip_relocation, ventura:       "73e002987e5d6fef0f608e0d547847a31cf0f051b6c4afac21383b675f72136e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17ef5e278367b76792ed55c9f8d2f85574b08f02aca17edc4cdfd1ac2b149b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd0ab209037e2a9b76d9a4fe8d81ff97e73c42540050a4ded4797cc663f0314"
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
