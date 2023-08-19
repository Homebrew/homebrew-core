class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.6.3",
      revision: "c739946e43f7984ecd315061e8bf832e3e542aeb"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c91eea5fec4beba242d3a630dafdeddf50fe266d7af3aceaa15110b30de8bec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "698ae5e4bc5195b09ef9d80ac629d295988e0f1985fe86586a0c724238beba17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea8215c6c89aca568a67d29619250de019c2fbabad0604a44ad4c6c5e2bf2213"
    sha256 cellar: :any_skip_relocation, ventura:        "245e937ed96aa7069689d5fa8847f0880a9e44c605358085d69b754ce46049a8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa80b9170c9ce6e0740a9606d109856d687fef908a019387fc114da522059cae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b64f38b65ceaa72f622a865360c55e9a039495b6ae67e0041a859673dfa8628f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebc7de57485e97e0c651580f51a00c9df7f079ce271012fe99215477f928833"
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
