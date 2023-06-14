class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.5.1",
      revision: "1c990f27087e8f18a7586ba4f1c2a524dde47db6"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c006b4970f32c2b77c6e8b0da5f430e79af943bb93b8df2501e10c65fed9268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b82365cfc0ac27e2b873bbd165bc19e092391aa3ebb7c5653ae1f5cf469bd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b1971ed591f34c0395e87db4513de61bcb1bc4b06741b8e66a980e2612f69d0"
    sha256 cellar: :any_skip_relocation, ventura:        "6a535ac0cd6463692b07fd88a1de84e46cab31a37737707555d87513ad606ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "babe9d3cc52ce4501872939d034f533cff5398cff6381d5a4218fe6d31d138d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a159ba7b5fbefbc8bd7764fdd941bed4201c4d8ec258771014fd8cc60e137c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f989ebc348b4ea443508d4d0b524fecaf8b1d605067439c706d78b505a7658fc"
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
