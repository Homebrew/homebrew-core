class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.16.tar.gz"
  sha256 "4d25b6e22557ce4d558b7bbb07f827d8467d698a8c9d54380a627bdd8ae74177"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2935b81f079d09eda409db2914834cd3f71f254243b911a01d46c8eba4905108"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2935b81f079d09eda409db2914834cd3f71f254243b911a01d46c8eba4905108"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2935b81f079d09eda409db2914834cd3f71f254243b911a01d46c8eba4905108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2935b81f079d09eda409db2914834cd3f71f254243b911a01d46c8eba4905108"
    sha256 cellar: :any_skip_relocation, sonoma:         "f20507f37f3a5a84f62bc6bb6e3cfa4b6eff58fbcc31cba9722f306938618634"
    sha256 cellar: :any_skip_relocation, ventura:        "f20507f37f3a5a84f62bc6bb6e3cfa4b6eff58fbcc31cba9722f306938618634"
    sha256 cellar: :any_skip_relocation, monterey:       "f20507f37f3a5a84f62bc6bb6e3cfa4b6eff58fbcc31cba9722f306938618634"
    sha256 cellar: :any_skip_relocation, big_sur:        "f20507f37f3a5a84f62bc6bb6e3cfa4b6eff58fbcc31cba9722f306938618634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e385b1192d1d88bcf3cb517b0fa884104609d3bd6519fcaa99370fe76bccc886"
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
