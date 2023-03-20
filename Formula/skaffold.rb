class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.2.0",
      revision: "bfc52e41ca7fbeac8a9f1da681118d14e197d6d4"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1bf7e896f6d190d78207e5abbe21af8d9d255f91a26cef5266e60d75ea8594d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b93f6a7d7f2fea74c667068233a4079677252e515840c033b7ee153ba58a091"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08e37b243af68873b6d88e3a16a42587c87916629367d52ca983fd9e757938f7"
    sha256 cellar: :any_skip_relocation, ventura:        "107927c6420b13d11e405ea8c4a055c59068853684086659fae49bd4cb8e0060"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb25dc8ff89be1f843928c44d70ae935ad75299e18e75ce7d60335907eadeb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cb3f764ae2acdaf732ab830ac6352aea358e6843fadefb3266bdf965399e7da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f18d851751c27b4c9c75f693e92b639b0c0a441e21c647222bea7555ff38c77"
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
