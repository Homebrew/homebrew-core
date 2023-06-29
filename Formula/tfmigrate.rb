class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.12.tar.gz"
  sha256 "9bb1fff7ec546d3bd4aaf0cb2f53afaa498bb7956a0556ebeaa377e02d7c6447"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25c5ed50dbbf6a523c55aecf5c838f5614eabd78e1647e8491b97810cfec651a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c5ed50dbbf6a523c55aecf5c838f5614eabd78e1647e8491b97810cfec651a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25c5ed50dbbf6a523c55aecf5c838f5614eabd78e1647e8491b97810cfec651a"
    sha256 cellar: :any_skip_relocation, ventura:        "99d6cf60f150c7e6a5bf07afa4222a3c6b83965af1a6b5eb11b113e191b26f08"
    sha256 cellar: :any_skip_relocation, monterey:       "99d6cf60f150c7e6a5bf07afa4222a3c6b83965af1a6b5eb11b113e191b26f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "99d6cf60f150c7e6a5bf07afa4222a3c6b83965af1a6b5eb11b113e191b26f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ccf45a62ee1962b729886a5f36caa7b19d23e917f0171ca1f4b2dbb109e1417"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
