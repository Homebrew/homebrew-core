class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.6.0",
      revision: "23c5c16b9fc777b87602aa27dcbe3136291959f3"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba413aa92acdfe42705a56abed90dd84031063972e7d1f32329ac75e8b9deaea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b40aa39b070f4ee7c704b7a4f3476f6de7bd30eff22365ee015d2762de9317cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26e949c3467208a6816c59c5f9d3f1a7c9409efc32164223b221c6961791700e"
    sha256 cellar: :any_skip_relocation, ventura:        "9ec3f2ed472ca8a2cd8a53a07fd09fe8e42494162a82ea7360dea4928f44f04e"
    sha256 cellar: :any_skip_relocation, monterey:       "4931a0b0d337b404bfbfddc0e7d39e51028bb5e1d32e22c6957bcfc23621202f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce5db2df27a28cd5559a65ad48a27025f573128389d019bb694c01d143712e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd555ce474d36a575b4bfa774412b60d1c769ac2d573bf530bc6c132d3adb04"
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
