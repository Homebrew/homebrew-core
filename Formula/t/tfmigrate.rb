class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.15.tar.gz"
  sha256 "548109032024278a2838c1c8bb2b7b874981daedafc1887c155812dd56e8940f"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f084c3e8a0ec8d7df8040ff455e4515508795e992ae0a4864fb567ee35b2b712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f084c3e8a0ec8d7df8040ff455e4515508795e992ae0a4864fb567ee35b2b712"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f084c3e8a0ec8d7df8040ff455e4515508795e992ae0a4864fb567ee35b2b712"
    sha256 cellar: :any_skip_relocation, ventura:        "676e6fef709aa486c024c10d00bfb4f8c9f9e45bf34f2530288b707d3f6999b7"
    sha256 cellar: :any_skip_relocation, monterey:       "676e6fef709aa486c024c10d00bfb4f8c9f9e45bf34f2530288b707d3f6999b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "676e6fef709aa486c024c10d00bfb4f8c9f9e45bf34f2530288b707d3f6999b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "886f3029559f4be3d0a30d414052e0aedabd4e9b0819b56da8a67a92ee597ead"
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
