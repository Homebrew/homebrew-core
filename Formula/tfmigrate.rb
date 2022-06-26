class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.3.tar.gz"
  sha256 "0bbf7ab411cea2359ad782e57a8ec99a1037f6b6761080f42a4b6e3e9455ffa3"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f93c9ba7ce89e022cf14eab90b3fdee735531d97651181ef5ca8cb4071a1c36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f93c9ba7ce89e022cf14eab90b3fdee735531d97651181ef5ca8cb4071a1c36"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3ab36cbacf4a1c73db6370705fa12d2a0d2bebde7572f9eee60a262fb003d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b3ab36cbacf4a1c73db6370705fa12d2a0d2bebde7572f9eee60a262fb003d9"
    sha256 cellar: :any_skip_relocation, catalina:       "0b3ab36cbacf4a1c73db6370705fa12d2a0d2bebde7572f9eee60a262fb003d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70c026fd49ac8bb6ea221f7ca3d30af8e860e5288c9de1683c975f9b0999a0a8"
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
