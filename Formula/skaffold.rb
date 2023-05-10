class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.4.1",
      revision: "fa03604c21fcf1db798a118dd7f8c11d086f0174"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2acb9a80030021bc68dd0e75cca7e63f1acc61bb1c9632fee3629ac2aee879ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173b45305ab84239519993b4f48038df356723637d4058a0bea64b4e64a02448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "998214a2767615bcc2ec0898379e6d2d9708cae04e42d4e45760e6b76464945e"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9fa4e1257ccc7e185e5909fe63d88d9478dfc4142255ed4b985980f45df145"
    sha256 cellar: :any_skip_relocation, monterey:       "73b033d543551fdc475073b31f603d7513b9a548a8e2e7e7f802f5d394267a15"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2ab1e1bb7ce6935351c5ae76b52e4b8b664711a5f937f40cbbaa452a7ff2b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ae3ccf9f1b74d652c09a22a32f5af79c61f61b350216b7a6f829c8bbabd322"
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
