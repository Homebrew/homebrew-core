class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.24.1",
      revision: "c44d98a365e26a091cf2cde5a2378054d2d345b2"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1bcd6a8414f6579c199bb4397639b7c2dfea8aabf97c82f3847c8fe2712b1253"
    sha256 cellar: :any_skip_relocation, big_sur:       "184930baccc8de5b202f94db6fe5d17a08f17009889e0870a4bd0c26f3a089e2"
    sha256 cellar: :any_skip_relocation, catalina:      "1bad8ab8aaf218cd472143e2576da492c37eb310a636591cde19ab05edfa7211"
    sha256 cellar: :any_skip_relocation, mojave:        "6fbba04e5a3682e9db137403ff473d68fc80d69cbeef2e04b8e3a58364a284a8"
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
    assert_equal '{"dockerfiles":["Dockerfile"]}', output
  end
end
