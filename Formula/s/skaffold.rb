class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.22.1",
      revision: "f9beeb7b68778673806c5e9a3b5748af916116cd"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0849044bb205ac43062de92906e8c00d0bd4cff54a69b9e10d055e9e64b644fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca4960d20548ce9777fe9aa9c063f50c34c9c7ad9324021765a830ab938e7644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b516d668ad0f5d6d84d8ce59b3107b45fac2f246a6feabd12cf11b65970feec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3c81e240bdf3c1b82051082dc84440261539aebcfe4ec9c023765a2dc83339b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f29836ba1b08a69c11c9d6eae3c9d80a7d0b9635370c0349b4e66279e33102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22cc208699863fbdd4d706865562f433f4b80c72f5ebb5054f50e7d2c90f55b0"
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
