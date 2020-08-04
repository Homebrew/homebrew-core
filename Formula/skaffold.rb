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
    sha256 "a069687bc6f37c4b1944c2458b26ddc686e39ec7a27e085eb5a5daff685ff210" => :catalina
    sha256 "ce8c22bc3aebd92f68b4989aa0e15d56751636251e703887b89d256f68ac3717" => :mojave
    sha256 "1f37c945aef5ef42522affd6b9ca52da97bd25e5b8dd81ea80dc573cca4fd9cc" => :high_sierra
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
