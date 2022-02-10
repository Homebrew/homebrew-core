class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.36.0",
      revision: "189a55291c18ac850277134d2b8f3eaa2c4f7a1d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64410afbc361578ba502009cc1aaf0f9b4f9bf21f973de160caeeef1314c6395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c60849037a24290df77a22b8df6b965e297d3f8345a708a8d779b5b11815595"
    sha256 cellar: :any_skip_relocation, monterey:       "16beba22e58939606fa422e57c2dda101a27720446bc38e2bb306429e1fa9d94"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a972bea1359696a3bcee58486cb2797bc8ecc22f54e8397244ad0bae4a49bf"
    sha256 cellar: :any_skip_relocation, catalina:       "7988a28b7c4a7c6b09b3900d71aab77e20b8134ef74dc032d71b99d3cf8d7596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53538b90b21692a039eba5968e8d5f8a8114eb53b2701e1a2297710d577f9c4"
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
