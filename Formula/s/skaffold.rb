class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.15.0",
      revision: "bffbfe0d97299ca2c843a0b45ddd51b0e8f6c28b"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3380911a448bd64f76f3c6f993b6d46eabdda48f71a4e6b56d7cb964cc5c97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c28713e2a73f417dd30025e55a73225b3209086e2bc49302797387208c1bac08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a1cea4f49f3449af1deeb0076205fe690748aa514a797fdfa5408b1c0dd69b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bc35426b7d4bb0b5229b09e3c71c270db62e8c4f59cb0807ec9fab437599d7a"
    sha256 cellar: :any_skip_relocation, ventura:       "a431f9b8b4f0ba8ec6eb6ae230e46306284f79126e794fa9409b35b1c7e9451b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305d1ea97258a495ec99ac7b65b745a5c7917b4987520622d5f2699f7512afb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b92b356315bd1b3e89c685673dc02a43cc8c992cec6e42e0b86c095dbe64406"
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
