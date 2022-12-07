class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.9.tar.gz"
  sha256 "8b4a8adabe30614baeb1c0045da6963d6e9847444cb710b2fddca6600264135a"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d223d6ff5c85b565235389d03455e73b2282c9c127256d05b94783cbe4e7b859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1430d8b6844d723db6b441c7a28da210f18a8cffb7e66f3848ad6c59fb189cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1430d8b6844d723db6b441c7a28da210f18a8cffb7e66f3848ad6c59fb189cb9"
    sha256 cellar: :any_skip_relocation, ventura:        "04609b3654c5e2428177df8d384c5052af3ee1b92632125c5ab0769e9e4c0a1d"
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
