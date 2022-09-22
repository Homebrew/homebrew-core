class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.8.tar.gz"
  sha256 "9e300368c5b1d13e60d1d2547e2c92bf2192f6bc04ede220c0fdbb674a5ce3f2"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e83c4dd2bf345bfc275a8a412ea5ef425d9b3ab5578563063522f133506f63a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e83c4dd2bf345bfc275a8a412ea5ef425d9b3ab5578563063522f133506f63a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a11cee662fd9872c76184ab29d146d3117ad8810ef1cfd79dcec75f5117c3ac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a11cee662fd9872c76184ab29d146d3117ad8810ef1cfd79dcec75f5117c3ac2"
    sha256 cellar: :any_skip_relocation, catalina:       "a11cee662fd9872c76184ab29d146d3117ad8810ef1cfd79dcec75f5117c3ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0198ca2a7368415e91c47868f4e0e9b7d02b31499af75c8d8d49589c0a3676"
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
