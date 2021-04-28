class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.23.0",
      revision: "e8f3c652112c338e75e03497bc8ab09b9081142d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e96e7329c8ea9fd1d7a8890e632e17f140b94e252101a4bbb25f150fdc1a1b55"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6bd78655c1d8ce3c353833d71e333a37ae27ffe144c307bd17156936abaf230"
    sha256 cellar: :any_skip_relocation, catalina:      "1d7208717d760052139a6c9e6ce0ad2a9c645d040c3df37ff6e58ca63d8d2420"
    sha256 cellar: :any_skip_relocation, mojave:        "cd3ba9ea728f43e8eb574cf35c0f39f64635953ae9f099e1b40f14f14e137965"
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
