class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.35.2",
      revision: "f8ae4e65bafdcfd39e4de67329b185432899c7ad"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d238a114c947e656b98a70fbdd1ed4646b9c3f38518914d7d81dae24de5045cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f192e4eae32d80f3c55bfc0543b39b7695a83d24ff0aa2f8a5901cd948b59a9"
    sha256 cellar: :any_skip_relocation, monterey:       "4cc6074f43f81ca3c064f2a54a8663285c8cd09feba84e10186c23f5ab2f2097"
    sha256 cellar: :any_skip_relocation, big_sur:        "91ccdd1e5d10afcf4747b68fa7f8505189af6a03222dfa355d5d20e88fbc85b2"
    sha256 cellar: :any_skip_relocation, catalina:       "303b59e77af323edb485e939cb57756f5df1f8912f6856623e31c28712b46e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15660950f0eb0b44eb269c052da95afc99275b391b90456d0b4d9dd3adb51077"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
