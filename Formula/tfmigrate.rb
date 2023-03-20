class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.11.tar.gz"
  sha256 "c7ac7febb01ef8c170f472362de440dee452002d7bf90e8ee2629e66221b3947"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e5fa86f5c93c3249cd4afa3202f59d3b6d3bb30707667c15df61cd005dbbce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5fa86f5c93c3249cd4afa3202f59d3b6d3bb30707667c15df61cd005dbbce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e5fa86f5c93c3249cd4afa3202f59d3b6d3bb30707667c15df61cd005dbbce5"
    sha256 cellar: :any_skip_relocation, ventura:        "680d71ad8593054af5be360334a337aa3e90a8611472c43cde72f69a1073b75e"
    sha256 cellar: :any_skip_relocation, monterey:       "680d71ad8593054af5be360334a337aa3e90a8611472c43cde72f69a1073b75e"
    sha256 cellar: :any_skip_relocation, big_sur:        "680d71ad8593054af5be360334a337aa3e90a8611472c43cde72f69a1073b75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2711d176345161297a6c09beeb1e4240f1d31cbba4c53c47d1a94eb043b8b79"
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
