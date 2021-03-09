class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.20.0",
      revision: "c48e97690d8daffd68141c2a68fcbe3df6f6936a"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c254794477d09d46820c3e8deb093e2c8ba18f182feaf1096357809ebf78593"
    sha256 cellar: :any_skip_relocation, big_sur:       "966929ab1b1762c7c7214adf64cd2989cadd2075ee415b1ae0472e43779e5983"
    sha256 cellar: :any_skip_relocation, catalina:      "939eee31c22c5e6c1c008a20d0e293b2b3eb18933622ec53ff66a26a8c53b3c5"
    sha256 cellar: :any_skip_relocation, mojave:        "a18e174916afb8bf4b79adbb261e4b8b235ca09537cce6d77eb309cf6cd9c1c5"
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
