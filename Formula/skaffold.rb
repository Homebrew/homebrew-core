class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.17.0",
      revision: "ad9c4899cf485f6931cb9de2ac3419b83081f73d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c569de5af0bda5d3dac33c6b349536416fc72bc68e98ec2b1c5a8529e910f63" => :big_sur
    sha256 "0f462bea4be142ccf776e2c0e6e2aa92ba052df07ab3e02c2fce5e715f192a33" => :catalina
    sha256 "1ba2e2ecb650e078683c21413b22c8dbeffeda4857f18579edbfc721c54a8bba" => :mojave
    sha256 "077abc866c7de26f5c46b3a68d69a24a6906c04961c97ac5dc1c71650709a7a4" => :high_sierra
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
