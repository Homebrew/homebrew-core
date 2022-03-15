class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.2.tar.gz"
  sha256 "a441f57cd64c32fb3c42f1c8c37ccffeed38aacd119b6c7415e8e073c194f947"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab15b9e69a491b7ffb6da7bc3d6381e350ae09f484d4ac62d0ee0dbc6b587087"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab15b9e69a491b7ffb6da7bc3d6381e350ae09f484d4ac62d0ee0dbc6b587087"
    sha256 cellar: :any_skip_relocation, monterey:       "f9cae2116d1cd3eefa00a0a9c80a8b1f6ae35b66e45ba7192dc5291651e19c67"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9cae2116d1cd3eefa00a0a9c80a8b1f6ae35b66e45ba7192dc5291651e19c67"
    sha256 cellar: :any_skip_relocation, catalina:       "f9cae2116d1cd3eefa00a0a9c80a8b1f6ae35b66e45ba7192dc5291651e19c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4afb8c11e09179ba2a899cc31420dfcb5a62a80bae4dfeabeed7e6aa9c1c610c"
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
