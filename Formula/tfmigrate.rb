class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.1.tar.gz"
  sha256 "0a4915f214729ad91df125df5ce735caab1d4f1b9a43375a0ed9bde7970a69f6"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43939fce4b807c3ec994b4324e0c5c84ec63394ce8600c92efa7804cce841931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43939fce4b807c3ec994b4324e0c5c84ec63394ce8600c92efa7804cce841931"
    sha256 cellar: :any_skip_relocation, monterey:       "dc29e81837cb994fcf8b2ea851cfa53018b65d36999dea05d55d16c91e7ae439"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc29e81837cb994fcf8b2ea851cfa53018b65d36999dea05d55d16c91e7ae439"
    sha256 cellar: :any_skip_relocation, catalina:       "dc29e81837cb994fcf8b2ea851cfa53018b65d36999dea05d55d16c91e7ae439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e874628816f2c5f83e25fb0191624c7a6ae40a3a9f1d29d0675ad4d9196637b9"
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
