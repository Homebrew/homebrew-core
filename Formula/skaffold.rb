class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.17.2",
      revision: "53e4063e12b41bc19c6cd3929d939f17ad2e88de"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "487907b1c24c5237fa479805a048e528d2350f27015c15f32a011eedce0f64e3" => :big_sur
    sha256 "50c361687cf63daf9d9189f49729e10880d9afe17078712354c75f0d7a84e565" => :catalina
    sha256 "a42adbf989f90fa81f6ad541a392461f56034e6228cae2884a507c6639e4ad47" => :mojave
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
