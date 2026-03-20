class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.18.1",
      revision: "fb3725ae78338a16ec39886dc4d1d3c04050df5f"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a7402bce9c0e7bf3d2aac81958af69b59dd191b36486b52965f8062b7f7c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd26b16e6d91e5114f9e8932ad226221daebb6614994dfe586eef14b04fd8dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06d0d0d8854066141811c1af9895e345df6b7562fba14f9eb6822f50ebf25083"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a96a0f2ffea05de8aae1783aab02b963d2776a5aecba7a9e38ef0fe611933a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae466d5983e09bb068a2e345d97d6cd9bd18e4cf45ca5ee61006cea66933125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e1e956c700f2331df10682111b705ea914e92490fea0941bcad06f65ef5499"
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
