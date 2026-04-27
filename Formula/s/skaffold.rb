class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.19.0",
      revision: "95531aa9b308e8f4f9618cd7f541361cef7865ab"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a51488edc3c425b39fefe1605faa42da0131fc9b02089f524ebaeb50d97788f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6491b14495d02e3b71652b46afbd18ee41c513d7a728d01c31c7875e420526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0691bc1f230a044cfcdf29db38430a349542e2593ff797109ad0b28c396c07a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b04f5ed7ae6e57bfd06c7ff46feb30a4e526a681d4689a316b4261b37aff1a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bf2341bb300d84464e4fca6fca06a395f187d7604fc9ae3641e281f4bb57ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e0a3341050aa50ff581565c197e8f4f18c63af5cf86f861f46519ab45e46ba9"
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
