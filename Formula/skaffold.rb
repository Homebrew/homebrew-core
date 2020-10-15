class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.15.0",
      revision: "c4dce04b0d692dce61051d14cf4a2c04c8c688bd"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "440819ba6d2d60fad05d499bd65d0df93cf2ea8989df0c3bfd9781e2e1e88be9" => :catalina
    sha256 "c6f00e055c03d13b1b130490d8ec692b2bbd01c3dd2587f2bfa91c980a0d410c" => :mojave
    sha256 "5e7debb8b27c3a63796ebac1cd98acbf1a75e049fe534059ab30c26b9e56f404" => :high_sierra
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
