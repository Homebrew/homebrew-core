class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.29.0",
      revision: "39371bb996a3c39c3d4fa8749cabe173c5f45b3a"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1449b041ed6e804165aecaf0111a4d137191ac3eaf18a012a04c1eb5883f3201"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a729018938c807ebcb2deb712d33b521b91e1676870b56102ab18c2c37e601a"
    sha256 cellar: :any_skip_relocation, catalina:      "96abb7c24c4f66ded2fbe9f3306f584f62b3bd03abf03863a63d3204acda38fa"
    sha256 cellar: :any_skip_relocation, mojave:        "ff4ca9f89c982e62d426bf7b9b2b550b4312776f9c163e466e77f4125de7f8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341e6c28ae62e7d8ed2a4c42cfe8669e14f2c6377d3206d02d6c012e67765c96"
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
