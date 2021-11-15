class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.2.11.tar.gz"
  sha256 "783a98b07450a321e612ac75a70c5e8e762d3e5cdf135944543deea5a257627a"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c8bb68fb204906912cd0ecaef40dc165769bba6b050c51bfae6328cff40c98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11c8bb68fb204906912cd0ecaef40dc165769bba6b050c51bfae6328cff40c98"
    sha256 cellar: :any_skip_relocation, monterey:       "2704bf5320586f5c9949f98481bacf7f8222d99843ca4a19397c540e4c448fa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2704bf5320586f5c9949f98481bacf7f8222d99843ca4a19397c540e4c448fa7"
    sha256 cellar: :any_skip_relocation, catalina:       "2704bf5320586f5c9949f98481bacf7f8222d99843ca4a19397c540e4c448fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ecd4e4b397602cdb999df541341c8e1bc5f5ed56060d415e62ca344ab42a9ff"
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
