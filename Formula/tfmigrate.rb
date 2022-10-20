class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.8.tar.gz"
  sha256 "9e300368c5b1d13e60d1d2547e2c92bf2192f6bc04ede220c0fdbb674a5ce3f2"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1430d8b6844d723db6b441c7a28da210f18a8cffb7e66f3848ad6c59fb189cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1430d8b6844d723db6b441c7a28da210f18a8cffb7e66f3848ad6c59fb189cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f30106a945a19e224c6f85fd166dfe38f12979eb245c138a3c3d87dd67c705"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4f30106a945a19e224c6f85fd166dfe38f12979eb245c138a3c3d87dd67c705"
    sha256 cellar: :any_skip_relocation, catalina:       "d4f30106a945a19e224c6f85fd166dfe38f12979eb245c138a3c3d87dd67c705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8adfe0b8d63461c44d24c072981fd243c917d9e0a04c37634543c16774088b0d"
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
