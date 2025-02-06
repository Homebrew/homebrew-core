class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.14.0",
      revision: "f132ab25adf1599c7fbdce733144991126565386"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c7a9a12223e92d0c2dd786c00e835515aca820c11aa0afdf634ffd109e9cd84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02411f2c1d277e6cced1e7600292154505d07d940e9965b825cc352dcef8ef69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6abb2b3baba0356bc5ad66342d62d744128ec4e9d5c3847cae2be64859b4033e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba5176faa942b5fecdf3e3ed18bb3edbdb5a2f546fc4da75f2edf09acd6e537"
    sha256 cellar: :any_skip_relocation, ventura:       "b87e8fcc8bbebd9deba20c6e48827663a3852b1699f79bda8d3155b3317f42f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caf4f8fb762ba28541e476312f96edd4500abc763f7ff26811d990a93907ac61"
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
