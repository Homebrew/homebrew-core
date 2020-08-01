class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.13.0",
      revision: "6520ff3fca78f1532542596bfe91ba51110a2c74"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6d044e89599bc50bb6c7bb527f653ad2b60ffc97918390aaef0edc8cc4168cb" => :catalina
    sha256 "4ec58a62b89267482ff1d2459595ced035124a8e8d82df0fe624a39ab1c7e4ee" => :mojave
    sha256 "644c590fdaaacf9fd645e20030d92b2c32991ed2417158101e350d2d3f3f2770" => :high_sierra
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
