class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.36.1",
      revision: "189a55291c18ac850277134d2b8f3eaa2c4f7a1d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  # This uses the `GithubLatest` strategy to work around an old `v2.2.3` tag
  # that is always seen as newer than the latest version. If Skaffold ever
  # reaches version 2.2.3, we can switch back to the `Git` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ccc268b3dd4655236a1b01adc3321ca32b7426339c2162a736c155add5b0958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73236d40d763b05c4955bed1dd53e1f8c5f3d048cf2ef5823e60f6ae15bda475"
    sha256 cellar: :any_skip_relocation, monterey:       "79bb642b48c392512a656e7b15c317e943a284f7170d85ccee4a6cb848cfe352"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed6a321dff4a5ff8a000ab3482cd3f0f28f53487d87323777a58d75d83656cd3"
    sha256 cellar: :any_skip_relocation, catalina:       "8ac016436b8410fb594cb7cf52fad238c3a5b7614f5bf598ad84e06dcbb8d5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea516f4af7b035d3dd473b9a9f45e05d0356e1c049dcb646f9255e92f313eadf"
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
