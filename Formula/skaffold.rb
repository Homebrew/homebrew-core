class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.26.1",
      revision: "438dae66fbf35a1c9ee23f21a6f6e8d991c3edc6"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "115bbe72c18063e797631991c64a6d08da1c53c69564da769cb0c9f0b4f6d2a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab5f75d57486e327482c5643182635c2f3eedc66420b7c6e6b5e1f9b84f45057"
    sha256 cellar: :any_skip_relocation, catalina:      "99992e6cb978f1ab17153e5b99edfe98ed7d05cafeb4c475854c0b9ad91e1f6b"
    sha256 cellar: :any_skip_relocation, mojave:        "43c654e8fe10c84e90a475e2107b84e2cb53c47ebf9ac613a0517036dee89d6f"
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
